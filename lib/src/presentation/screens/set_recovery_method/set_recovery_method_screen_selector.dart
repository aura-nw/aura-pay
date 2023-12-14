import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'set_recovery_method_screen_bloc.dart';
import 'set_recovery_method_screen_state.dart';

class SetRecoveryMethodScreenIsReadySelector extends BlocSelector<
    SetRecoveryMethodScreenBloc, SetRecoveryMethodScreenState, bool> {
  SetRecoveryMethodScreenIsReadySelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.isReady,
          builder: (_, isReady) => builder(
            isReady,
          ),
        );
}

class SetRecoveryMethodScreenMethodSelector extends BlocSelector<
    SetRecoveryMethodScreenBloc,
    SetRecoveryMethodScreenState,
    RecoverOptionType> {
  SetRecoveryMethodScreenMethodSelector({
    Key? key,
    required Widget Function(RecoverOptionType) builder,
  }) : super(
          key: key,
          selector: (state) => state.selectedMethod,
          builder: (_, selectedMethod) => builder(
            selectedMethod,
          ),
        );
}
