import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'signed_in_pick_account_bloc.dart';
import 'signed_in_pick_account_state.dart';

class SignedInPickAccountIsReadySubmitSelector extends BlocSelector<
    SignedInPickAccountBloc, SignedInPickAccountState, bool> {
  SignedInPickAccountIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          builder: (_, isReady) => builder(isReady),
          key: key,
          selector: (state) => state.isReadySubmit,
        );
}

class SignedInPickAccountAccountNameSelector extends BlocSelector<
    SignedInPickAccountBloc, SignedInPickAccountState, String> {
  SignedInPickAccountAccountNameSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          builder: (_, accountName) => builder(accountName),
          key: key,
          selector: (state) => state.accountName,
        );
}
