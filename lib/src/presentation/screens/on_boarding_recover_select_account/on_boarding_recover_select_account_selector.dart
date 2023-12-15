import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_recover_select_account_bloc.dart';
import 'on_boarding_recover_select_account_state.dart';

final class OnboardingRecoverSelectAccountStatusSelector extends BlocSelector<
    OnBoardingRecoverSelectAccountBloc,
    OnboardingRecoverSelectAccountState,
    OnboardingRecoverSelectAccountStatus> {
  OnboardingRecoverSelectAccountStatusSelector({
    Key? key,
    required Widget Function(OnboardingRecoverSelectAccountStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(
            status,
          ),
        );
}

final class OnboardingRecoverSelectAccountAccountsSelector extends BlocSelector<
    OnBoardingRecoverSelectAccountBloc,
    OnboardingRecoverSelectAccountState,
    List<AuraAccount>> {
  OnboardingRecoverSelectAccountAccountsSelector({
    Key? key,
    required Widget Function(List<AuraAccount>) builder,
  }) : super(
          key: key,
          selector: (state) => state.accounts,
          builder: (_, accounts) => builder(
            accounts,
          ),
        );
}

final class OnboardingRecoverSelectAccountAccountSelectedSelector extends BlocSelector<
    OnBoardingRecoverSelectAccountBloc,
    OnboardingRecoverSelectAccountState,
    AuraAccount?> {
  OnboardingRecoverSelectAccountAccountSelectedSelector({
    Key? key,
    required Widget Function(AuraAccount?) builder,
  }) : super(
          key: key,
          selector: (state) => state.selectedAccount,
          builder: (_, selectedAccount) => builder(
            selectedAccount,
          ),
        );
}
