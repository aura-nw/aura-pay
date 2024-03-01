import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'recovery_method_confirmation_screen_bloc.dart';
import 'recovery_method_confirmation_screen_state.dart';

final class RecoveryMethodConfirmationScreenFeeSelector extends BlocSelector<
    RecoveryMethodConfirmationBloc, RecoveryMethodConfirmationState, String> {
  RecoveryMethodConfirmationScreenFeeSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          key: key,
          selector: (state) => state.transactionFee,
          builder: (_, fee) => builder(
            fee,
          ),
        );
}

final class RecoveryMethodConfirmationScreenIsShowFullMsgSelector extends BlocSelector<
    RecoveryMethodConfirmationBloc, RecoveryMethodConfirmationState, bool> {
  RecoveryMethodConfirmationScreenIsShowFullMsgSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.isShowFullMsg,
          builder: (_, isShowFullMsg) => builder(
            isShowFullMsg,
          ),
        );
}
