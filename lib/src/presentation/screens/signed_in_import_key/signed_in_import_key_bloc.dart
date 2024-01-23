import 'dart:async';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

import 'signed_in_import_key_state.dart';
import 'singed_in_import_key_event.dart';

class SignedInImportKeyBloc
    extends Bloc<SignedInImportKeyEvent, SignedInImportKeyState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;

  SignedInImportKeyBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._accountUseCase,
    this._controllerKeyUseCase,
    this._authUseCase,
    this._deviceManagementUseCase,
  ) : super(
          const SignedInImportKeyState(),
        ) {
    on(_onSelectAccountType);
    on(_onSelectImportType);
    on(_onInputKey);
    on(_onImport);
    on(_onInit);

    add(
      const SignedInImportKeyOnInit(),
    );
  }

  void _onInit(
    SignedInImportKeyOnInit event,
    Emitter<SignedInImportKeyState> emit,
  ) async {
    final accounts = await _accountUseCase.getAccounts();

    emit(
      state.copyWith(
        accounts: accounts,
      ),
    );
  }

  void _onSelectAccountType(
    SignedInImportKeyOnSelectAccountTypeEvent event,
    Emitter<SignedInImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        pyxisWalletType: event.accountType,
        key: '',
        isReadySubmit: false,
      ),
    );
  }

  void _onSelectImportType(
    SignedInImportKeyOnSelectImportTypeEvent event,
    Emitter<SignedInImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        importWalletType: event.importType,
        key: '',
        isReadySubmit: false,
      ),
    );
  }

  void _onInputKey(
    SignedInImportKeyOnInputKeyEvent event,
    Emitter<SignedInImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        key: event.key,
        isReadySubmit: event.key.isNotEmpty,
      ),
    );
  }

  void _onImport(
    SignedInImportKeyOnSubmitEvent event,
    Emitter<SignedInImportKeyState> emit,
  ) async {
    if (state.pyxisWalletType == PyxisWalletType.smartAccount) return;

    emit(
      state.copyWith(
        status: SignedInImportKeyStatus.onLoading,
      ),
    );
    try {
      switch (state.pyxisWalletType) {
        case PyxisWalletType.smartAccount:
          break;
        case PyxisWalletType.normalWallet:
          final wallet = await _walletUseCase.importWallet(
            privateKeyOrPassPhrase: state.key,
          );

          final bool isExistsAccount = state.accounts.firstWhereOrNull(
                (ac) => ac.address == wallet.bech32Address,
              ) !=
              null;

          if(isExistsAccount){
            emit(
              state.copyWith(
                status: SignedInImportKeyStatus.existsAccount,
              ),
            );
          }else{
            // Register device to create access token
            unawaited(
              _createToken(
                address: wallet.bech32Address,
              ),
            );

            await _accountUseCase.saveAccount(
              address: wallet.bech32Address,
              type: AuraAccountType.normal,
              accountName: PyxisAccountConstant.unName,
            );

            await _controllerKeyUseCase.saveKey(
              address: wallet.bech32Address,
              key: state.key,
            );

            emit(
              state.copyWith(
                status: SignedInImportKeyStatus.onImportAccountSuccess,
              ),
            );
          }
          break;
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: SignedInImportKeyStatus.onImportAccountError,
        ),
      );
    }
  }

  Future<void> _createToken({
    required String address,
  }) async {
    try{
      final String accessToken = await AuthHelper.registerOrSignIn(
        deviceManagementUseCase: _deviceManagementUseCase,
        authUseCase: _authUseCase,
        privateKey: AuraWalletHelper.getPrivateKeyFromString(
          state.key,
        ),
      );

      await AuthHelper.saveTokenByWalletAddress(
        authUseCase: _authUseCase,
        walletAddress: address,
        accessToken: accessToken,
      );
    }catch(e){
      LogProvider.log(e.toString());
    }
  }
}
