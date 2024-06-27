import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controller_key_management_cubit.dart';
import 'controller_key_management_state.dart';

class ControllerKeyManagementStatusSelector extends BlocSelector<
    ControllerKeyManagementCubit,
    ControllerKeyManagementState,
    ControllerKeyManagementStatus> {
  ControllerKeyManagementStatusSelector({
    Key? key,
    required Widget Function(ControllerKeyManagementStatus status) builder,
  }) : super(
          key: key,
          builder: (_, status) => builder(status),
          selector: (state) => state.status,
        );
}

class ControllerKeyManagementAccountsSelector extends BlocSelector<
    ControllerKeyManagementCubit,
    ControllerKeyManagementState,
    List<AuraAccount>> {
  ControllerKeyManagementAccountsSelector({
    Key? key,
    required Widget Function(List<AuraAccount> accounts) builder,
  }) : super(
          key: key,
          builder: (_, accounts) => builder(accounts),
          selector: (state) => state.accounts,
        );
}
