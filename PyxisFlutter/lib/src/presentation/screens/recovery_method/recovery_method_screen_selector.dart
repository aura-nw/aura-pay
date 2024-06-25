import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'recovery_method_screen_bloc.dart';
import 'recovery_method_screen_state.dart';

final class RecoveryMethodScreenStatusSelector extends BlocSelector<
    RecoveryMethodScreenBloc,
    RecoveryMethodScreenState,
    RecoveryMethodScreenStatus> {
  RecoveryMethodScreenStatusSelector({
    Key? key,
    required Widget Function(RecoveryMethodScreenStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(
            status,
          ),
        );
}

final class RecoveryMethodScreenAccountsSelector extends BlocSelector<
    RecoveryMethodScreenBloc,
    RecoveryMethodScreenState,
    List<AuraAccount>> {
  RecoveryMethodScreenAccountsSelector({
    Key? key,
    required Widget Function( List<AuraAccount>) builder,
  }) : super(
          key: key,
          selector: (state) => state.accounts,
          builder: (_, accounts) => builder(
            accounts,
          ),
        );
}
