import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'on_boarding_recover_sign_bloc.dart';
import 'on_boarding_recover_sign_state.dart';

final class OnBoardingRecoverSignFeeSelector extends BlocSelector<
    OnBoardingRecoverSignBloc, OnBoardingRecoverSignState, String> {
  OnBoardingRecoverSignFeeSelector({
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

final class OnBoardingRecoverSignIsShowFullMsgSelector extends BlocSelector<
    OnBoardingRecoverSignBloc, OnBoardingRecoverSignState, bool> {
  OnBoardingRecoverSignIsShowFullMsgSelector({
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

final class OnBoardingRecoverSignMessageSelector extends BlocSelector<
    OnBoardingRecoverSignBloc, OnBoardingRecoverSignState, MsgRecover?> {
  OnBoardingRecoverSignMessageSelector({
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
