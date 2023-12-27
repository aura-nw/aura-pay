import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'singed_in_recover_select_account_event.dart';
import 'singed_in_recover_select_account_state.dart';

final class SingedInRecoverSelectAccountBloc extends Bloc<
    SingedInRecoverSelectAccountEvent, SingedInRecoverSelectAccountState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final WalletUseCase _walletUseCase;
  final Web3AuthUseCase _web3authUseCase;

  SingedInRecoverSelectAccountBloc(
    this._smartAccountUseCase,
    this._web3authUseCase,
    this._walletUseCase, {
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
      final String backupPrivateKey = await _web3authUseCase.getPrivateKey();

      final wallet = await _walletUseCase.importWallet(
        privateKeyOrPassPhrase: backupPrivateKey,
      );

      List<PyxisRecoveryAccount> accounts =
          await _smartAccountUseCase.getRecoveryAccountByAddress(
        recoveryAddress: wallet.bech32Address,
      );

      emit(
        state.copyWith(
          status: SingedInRecoverSelectAccountStatus.loaded,
          accounts: accounts,
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

    emit(
      state.copyWith(
        selectedAccount: event.account,
      ),
    );
  }
}
