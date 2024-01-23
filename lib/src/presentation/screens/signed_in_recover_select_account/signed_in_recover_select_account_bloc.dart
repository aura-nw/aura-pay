import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

import 'singed_in_recover_select_account_event.dart';
import 'singed_in_recover_select_account_state.dart';

final class SingedInRecoverSelectAccountBloc extends Bloc<
    SingedInRecoverSelectAccountEvent, SingedInRecoverSelectAccountState> {
  final WalletUseCase _walletUseCase;
  final Web3AuthUseCase _web3authUseCase;
  final RecoveryUseCase _recoveryUseCase;
  final AuraAccountUseCase _auraAccountUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;

  SingedInRecoverSelectAccountBloc(
    this._web3authUseCase,
    this._walletUseCase,
    this._recoveryUseCase,
    this._auraAccountUseCase,
    this._authUseCase,
    this._deviceManagementUseCase, {
    required GoogleAccount googleAccount,
  }) : super(
          SingedInRecoverSelectAccountState(
            googleAccount: googleAccount,
          ),
        ) {
    on(_onFetchAccount);
    on(_onSelectAccount);
  }

  void _onFetchAccount(
    SingedInRecoverSelectAccountEventFetchAccount account,
    Emitter<SingedInRecoverSelectAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SingedInRecoverSelectAccountStatus.loading,
      ),
    );
    try {
      final List<AuraAccount> auraAccounts =
          await _auraAccountUseCase.getAccounts();

      final String backupPrivateKey = await _web3authUseCase.getPrivateKey();

      final wallet = await _walletUseCase.importWallet(
        privateKeyOrPassPhrase: backupPrivateKey,
      );

      final String accessToken = await AuthHelper.registerOrSignIn(
        deviceManagementUseCase: _deviceManagementUseCase,
        authUseCase: _authUseCase,
        privateKey: AuraWalletHelper.getPrivateKeyFromString(
          backupPrivateKey,
        ),
      );

      final String recoveryAddress = wallet.bech32Address;

      await AuthHelper.saveTokenByWalletAddress(
        authUseCase: _authUseCase,
        walletAddress: recoveryAddress,
        accessToken: accessToken,
      );

      List<PyxisRecoveryAccount> accounts =
          await _recoveryUseCase.getRecoveryAccountByAddress(
        recoveryAddress: recoveryAddress,
        tokenKey: AuthHelper.createAccessTokenKey(
          walletAddress: recoveryAddress,
        ),
      );

      emit(
        state.copyWith(
          status: SingedInRecoverSelectAccountStatus.loaded,
          accounts: accounts,
          auraAccounts: auraAccounts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SingedInRecoverSelectAccountStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onSelectAccount(
    SingedInRecoverSelectAccountEventSelectAccount event,
    Emitter<SingedInRecoverSelectAccountState> emit,
  ) {
    if (state.selectedAccount?.id == event.account.id) return;

    // Check exists account
    bool isExistsAccount = state.auraAccounts.firstWhereOrNull(
            (ac) => ac.address == event.account.smartAccountAddress) !=
        null;

    // If exists account. Show error message to users.
    if (isExistsAccount) {
      emit(
        state.copyWith(
          status: SingedInRecoverSelectAccountStatus.existsAccount,
        ),
      );
    } else {
      // If not. Choose this account.
      emit(
        state.copyWith(
          selectedAccount: event.account,
        ),
      );
    }
  }
}
