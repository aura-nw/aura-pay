import 'dart:async';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'on_boarding_import_key_event.dart';
import 'on_boarding_import_key_state.dart';

class OnBoardingImportKeyBloc
    extends Bloc<OnBoardingImportKeyEvent, OnBoardingImportKeyState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final AuraAccountUseCase _accountUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;

  OnBoardingImportKeyBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._accountUseCase,
    this._authUseCase,
    this._deviceManagementUseCase,
  ) : super(
          const OnBoardingImportKeyState(),
        ) {
    on(_onSelectAccountType);
    on(_onSelectImportType);
    on(_onInputKey);
    on(_onImport);
  }

  void _onSelectAccountType(
    OnBoardingImportKeyOnSelectAccountTypeEvent event,
    Emitter<OnBoardingImportKeyState> emit,
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
    OnBoardingImportKeyOnSelectImportTypeEvent event,
    Emitter<OnBoardingImportKeyState> emit,
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
    OnBoardingImportKeyOnInputKeyEvent event,
    Emitter<OnBoardingImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        key: event.key,
        isReadySubmit: event.key.isNotEmpty,
      ),
    );
  }

  void _onImport(
    OnBoardingImportKeyOnSubmitEvent event,
    Emitter<OnBoardingImportKeyState> emit,
  ) async {
    if (state.pyxisWalletType == PyxisWalletType.smartAccount) return;

    emit(
      state.copyWith(
        status: OnBoardingImportKeyStatus.onLoading,
      ),
    );
    try {
      switch (state.pyxisWalletType) {
        case PyxisWalletType.smartAccount:
          break;
        case PyxisWalletType.normalWallet:
          // Import wallet
          final wallet = await _walletUseCase.importWallet(
            privateKeyOrPassPhrase: state.key,
          );

          // Register device to create access token
          unawaited(
            _createToken(
              address: wallet.bech32Address,
            ),
          );

          // Save account
          await _accountUseCase.saveAccount(
            address: wallet.bech32Address,
            type: AuraAccountType.normal,
            accountName: PyxisAccountConstant.unName,
          );

          // Save controller key
          await _controllerKeyUseCase.saveKey(
            address: wallet.bech32Address,
            key: state.key,
          );

          emit(
            state.copyWith(
              status: OnBoardingImportKeyStatus.onImportAccountSuccess,
            ),
          );
          break;
      }
    } catch (e) {
      // Handle error
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: OnBoardingImportKeyStatus.onImportAccountError,
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
