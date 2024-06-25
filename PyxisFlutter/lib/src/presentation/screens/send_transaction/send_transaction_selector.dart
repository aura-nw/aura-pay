import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'send_transaction_bloc.dart';
import 'send_transaction_state.dart';

final class SendTransactionStatusSelector extends BlocSelector<
    SendTransactionBloc, SendTransactionState, SendTransactionStatus> {
  SendTransactionStatusSelector({
    Key? key,
    required Widget Function(SendTransactionStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(
            status,
          ),
        );
}

final class SendTransactionIsReadySubmitSelector extends BlocSelector<
    SendTransactionBloc, SendTransactionState, bool> {
  SendTransactionIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.isReadySubmit,
          builder: (_, isReadySubmit) => builder(
            isReadySubmit,
          ),
        );
}

final class SendTransactionSenderSelector extends BlocSelector<
    SendTransactionBloc, SendTransactionState, AuraAccount?> {
  SendTransactionSenderSelector({
    Key? key,
    required Widget Function(AuraAccount?) builder,
  }) : super(
          key: key,
          selector: (state) => state.sender,
          builder: (_, sender) => builder(
            sender,
          ),
        );
}

final class SendTransactionBalanceSelector
    extends BlocSelector<SendTransactionBloc, SendTransactionState, String> {
  SendTransactionBalanceSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          key: key,
          selector: (state) => state.balance,
          builder: (_, balance) => builder(
            balance,
          ),
        );
}
