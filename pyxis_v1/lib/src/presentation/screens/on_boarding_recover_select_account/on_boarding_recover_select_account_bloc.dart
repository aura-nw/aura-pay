import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'on_boarding_recover_select_account_event.dart';

import 'on_boarding_recover_select_account_state.dart';

final class OnBoardingRecoverSelectAccountBloc extends Bloc<
    OnBoardingRecoverSelectAccountEvent, OnboardingRecoverSelectAccountState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final WalletUseCase _walletUseCase;
  final Web3AuthUseCase _web3authUseCase;
  final RecoveryUseCase _recoveryUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;

  OnBoardingRecoverSelectAccountBloc(
    this._smartAccountUseCase,
    this._walletUseCase,
    this._web3authUseCase,
    this._recoveryUseCase,
    this._authUseCase,
    this._deviceManagementUseCase, {
    required GoogleAccount googleAccount,
  }) : super(
          OnboardingRecoverSelectAccountState(
            googleAccount: googleAccount,
          ),
        ) {
    on(_onFetchAccount);
    on(_onSelectAccount);
  }

  void _onFetchAccount(
    OnBoardingRecoverSelectAccountEventFetchAccount account,
    Emitter<OnboardingRecoverSelectAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OnboardingRecoverSelectAccountStatus.loading,
      ),
    );
    try {
      final String backupPrivateKey = await _web3authUseCase.getPrivateKey();

      final wallet = await _walletUseCase.importWallet(
        privateKeyOrPassPhrase: backupPrivateKey,
      );

      final String recoveryAddress = wallet.bech32Address;

      // final String accessToken = await AuthHelper.registerOrSignIn(
      //   deviceManagementUseCase: _deviceManagementUseCase,
      //   authUseCase: _authUseCase,
      //   privateKey: AuraWalletHelper.getPrivateKeyFromString(
      //     backupPrivateKey,
      //   ),
      // );
      //
      // await AuthHelper.saveTokenByWalletAddress(
      //   authUseCase: _authUseCase,
      //   walletAddress: recoveryAddress,
      //   accessToken: accessToken,
      // );

      final List<PyxisRecoveryAccount> accounts =
          await _recoveryUseCase.getRecoveryAccountByAddress(
        recoveryAddress: recoveryAddress,
        tokenKey: AuthHelper.createAccessTokenKey(
          walletAddress: recoveryAddress,
        ),
      );

      emit(
        state.copyWith(
          status: OnboardingRecoverSelectAccountStatus.loaded,
          accounts: accounts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingRecoverSelectAccountStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onSelectAccount(
    OnBoardingRecoverSelectAccountEventSelectAccount event,
    Emitter<OnboardingRecoverSelectAccountState> emit,
  ) {
    if (state.selectedAccount?.id == event.account.id) return;

    emit(
      state.copyWith(
        selectedAccount: event.account,
      ),
    );
  }
}
