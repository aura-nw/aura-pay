import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'send_transaction_confirmation_bloc.dart';
import 'send_transaction_confirmation_state.dart';

class SendTransactionConfirmationFeeSelector extends BlocSelector<
    SendTransactionConfirmationBloc, SendTransactionConfirmationState, String> {
  SendTransactionConfirmationFeeSelector(
      {Key? key, required Widget Function(String) builder})
      : super(
          key: key,
          selector: (state) => state.transactionFee,
          builder: (_, fee) => builder(fee),
        );
}

class SendTransactionConfirmationAmountSelector extends BlocSelector<
    SendTransactionConfirmationBloc, SendTransactionConfirmationState, String> {
  SendTransactionConfirmationAmountSelector(
      {Key? key, required Widget Function(String) builder})
      : super(
          key: key,
          selector: (state) => state.amount,
          builder: (_, amount) => builder(amount),
        );
}

class SendTransactionConfirmationIsShowFullMessageSelector extends BlocSelector<
    SendTransactionConfirmationBloc, SendTransactionConfirmationState, bool> {
  SendTransactionConfirmationIsShowFullMessageSelector(
      {Key? key, required Widget Function(bool) builder})
      : super(
          key: key,
          selector: (state) => state.isShowFullMessage,
          builder: (_, isShowFullMessage) => builder(isShowFullMessage),
        );
}
