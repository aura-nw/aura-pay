import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_recover_select_account_event.dart';

import 'on_boarding_recover_select_account_state.dart';

final class OnBoardingRecoverSelectAccountBloc extends Bloc<
    OnBoardingRecoverSelectAccountEvent, OnboardingRecoverSelectAccountState> {
  /// Fake after get from server
  final AuraAccountUseCase _accountUseCase;

  OnBoardingRecoverSelectAccountBloc(
    this._accountUseCase, {
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
      List<AuraAccount> accounts = await _accountUseCase.getAccounts();

      accounts = accounts
          .where(
            (e) => e.method?.value == state.googleAccount.email,
          )
          .toList();

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
    if(state.selectedAccount?.id == event.account.id) return;

    emit(
      state.copyWith(
        selectedAccount: event.account,
      ),
    );
  }
}
