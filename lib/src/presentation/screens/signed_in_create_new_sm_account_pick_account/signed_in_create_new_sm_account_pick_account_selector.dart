import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'signed_in_create_new_sm_account_pick_account_bloc.dart';
import 'signed_in_create_new_sm_account_pick_account_state.dart';

class SignedInCreateNewSmAccountPickAccountIsReadySubmitSelector extends BlocSelector<
    SignedInCreateNewSmAccountPickAccountBloc, SignedInCreateNewSmAccountPickAccountState, bool> {
  SignedInCreateNewSmAccountPickAccountIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          builder: (_, isReady) => builder(isReady),
          key: key,
          selector: (state) => state.isReadySubmit,
        );
}
