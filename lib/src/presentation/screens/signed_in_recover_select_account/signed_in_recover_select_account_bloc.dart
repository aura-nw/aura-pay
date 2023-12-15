import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'singed_in_recover_select_account_event.dart';
import 'singed_in_recover_select_account_state.dart';

final class SingedInRecoverSelectAccountBloc extends Bloc<
    SingedInRecoverSelectAccountEvent, SingedInRecoverSelectAccountState> {
  /// Fake after get from server
  final AuraAccountUseCase _accountUseCase;

  SingedInRecoverSelectAccountBloc(
    this._accountUseCase, {
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
      List<AuraAccount> accounts = await _accountUseCase.getAccounts();

      accounts = accounts
          .where(
            (e) => e.method?.value == state.googleAccount.email,
          )
          .toList();

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
    if(state.selectedAccount?.id == event.account.id) return;

    emit(
      state.copyWith(
        selectedAccount: event.account,
      ),
    );
  }
}
