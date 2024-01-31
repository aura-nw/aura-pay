import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'signed_in_recover_select_account_bloc.dart';
import 'singed_in_recover_select_account_state.dart';

final class SingedInRecoverSelectAccountStatusSelector extends BlocSelector<
    SingedInRecoverSelectAccountBloc,
    SingedInRecoverSelectAccountState,
    SingedInRecoverSelectAccountStatus> {
  SingedInRecoverSelectAccountStatusSelector({
    Key? key,
    required Widget Function(SingedInRecoverSelectAccountStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(
            status,
          ),
        );
}

final class SignedInRecoverSelectAccountAccountsSelector extends BlocSelector<
    SingedInRecoverSelectAccountBloc,
    SingedInRecoverSelectAccountState,
    List<PyxisRecoveryAccount>> {
  SignedInRecoverSelectAccountAccountsSelector({
    Key? key,
    required Widget Function(List<PyxisRecoveryAccount>) builder,
  }) : super(
          key: key,
          selector: (state) => state.accounts,
          builder: (_, accounts) => builder(
            accounts,
          ),
        );
}

final class SignedInRecoverSelectAccountAccountSelectedSelector extends BlocSelector<
    SingedInRecoverSelectAccountBloc,
    SingedInRecoverSelectAccountState,
    PyxisRecoveryAccount?> {
  SignedInRecoverSelectAccountAccountSelectedSelector({
    Key? key,
    required Widget Function(PyxisRecoveryAccount?) builder,
  }) : super(
          key: key,
          selector: (state) => state.selectedAccount,
          builder: (_, selectedAccount) => builder(
            selectedAccount,
          ),
        );
}

final class SignedInRecoverSelectAccountAuraAccountsSelector extends BlocSelector<
    SingedInRecoverSelectAccountBloc,
    SingedInRecoverSelectAccountState,
    List<AuraAccount>> {
  SignedInRecoverSelectAccountAuraAccountsSelector({
    Key? key,
    required Widget Function(List<AuraAccount>) builder,
  }) : super(
    key: key,
    selector: (state) => state.auraAccounts,
    builder: (_, accounts) => builder(
      accounts,
    ),
  );
}
