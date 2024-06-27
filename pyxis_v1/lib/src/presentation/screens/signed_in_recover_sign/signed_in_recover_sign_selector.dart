import 'package:aura_smart_account/aura_smart_account.dart';
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

final class SignedInRecoverSignIsShowFullMsgSelector extends BlocSelector<
    SignedInRecoverSignBloc, SignedInRecoverSignState, bool> {
  SignedInRecoverSignIsShowFullMsgSelector({
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

final class SignedInRecoverSignMsgSelector extends BlocSelector<
    SignedInRecoverSignBloc, SignedInRecoverSignState, MsgRecover?> {
  SignedInRecoverSignMsgSelector({
    Key? key,
    required Widget Function(MsgRecover?) builder,
  }) : super(
          key: key,
          selector: (state) => state.msgRecover,
          builder: (_, msgRecover) => builder(
            msgRecover,
          ),
        );
}
