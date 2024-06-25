import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'confirm_transaction_screen_state.dart';
import 'confirm_transaction_screen_bloc.dart';

final class WalletConnectConfirmTransactionScreenFeeSelector
    extends BlocSelector<WalletConnectConfirmTransactionBloc,
        WalletConnectConfirmTransactionState, String> {
  WalletConnectConfirmTransactionScreenFeeSelector({
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
