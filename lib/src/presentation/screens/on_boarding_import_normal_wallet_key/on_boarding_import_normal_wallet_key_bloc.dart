import 'dart:async';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';

import 'on_boarding_import_normal_wallet_key_event.dart';
import 'on_boarding_import_normal_wallet_key_state.dart';

class OnBoardingImportNormalWalletKeyBloc extends Bloc<
    OnBoardingImportNormalWalletKeyEvent,
    OnBoardingImportNormalWalletKeyState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final AuraAccountUseCase _accountUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;

  OnBoardingImportNormalWalletKeyBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._accountUseCase,
    this._authUseCase,
    this._deviceManagementUseCase,
  ) : super(
          const OnBoardingImportNormalWalletKeyState(),
        ) {
    on(_onSelectImportType);
    on(_onInputKey);
    on(_onImport);
    on(_onChangeShowPrivateKey);
  }

  void _onSelectImportType(
    OnBoardingImportNormalWalletKeyOnSelectImportTypeEvent event,
    Emitter<OnBoardingImportNormalWalletKeyState> emit,
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
    OnBoardingImportNormalWalletKeyOnInputKeyEvent event,
    Emitter<OnBoardingImportNormalWalletKeyState> emit,
  ) {
    emit(
      state.copyWith(
        key: event.key,
        isReadySubmit: event.key.isNotEmpty,
      ),
    );
  }

  void _onImport(
    OnBoardingImportNormalWalletKeyOnSubmitEvent event,
    Emitter<OnBoardingImportNormalWalletKeyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OnBoardingImportNormalWalletKeyStatus.onLoading,
      ),
    );
    try {
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
          status:
          OnBoardingImportNormalWalletKeyStatus.onImportAccountSuccess,
        ),
      );
    } catch (e) {
      // Handle error
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: OnBoardingImportNormalWalletKeyStatus.onImportAccountError,
        ),
      );
    }
  }

  Future<void> _createToken({
    required String address,
  }) async {
    try {
      // final String accessToken = await AuthHelper.registerOrSignIn(
      //   deviceManagementUseCase: _deviceManagementUseCase,
      //   authUseCase: _authUseCase,
      //   privateKey: AuraWalletHelper.getPrivateKeyFromString(
      //     state.key,
      //   ),
      // );
      //
      // await AuthHelper.saveTokenByWalletAddress(
      //   authUseCase: _authUseCase,
      //   walletAddress: address,
      //   accessToken: accessToken,
      // );
    } catch (e) {
      LogProvider.log(e.toString());
    }
  }

  void _onChangeShowPrivateKey(
      OnBoardingImportNormalWalletKeyOnChangeShowPrivateKeyEvent event,
      Emitter<OnBoardingImportNormalWalletKeyState> emit) {
    emit(
      state.copyWith(
        showPrivateKey: !state.showPrivateKey,
      ),
    );
  }
}
