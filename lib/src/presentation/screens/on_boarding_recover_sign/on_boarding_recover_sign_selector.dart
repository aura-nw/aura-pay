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
