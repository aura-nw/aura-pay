import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'signed_in_recover_sign_bloc.dart';
import 'signed_in_recover_sign_state.dart';

final class SignedInRecoverSignFeeSelector extends BlocSelector<
    SignedInRecoverSignBloc, SignedInRecoverSignState, String> {
  SignedInRecoverSignFeeSelector({
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
