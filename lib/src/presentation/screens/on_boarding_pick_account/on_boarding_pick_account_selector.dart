import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_pick_account_bloc.dart';
import 'on_boarding_pick_account_state.dart';
import 'package:flutter/material.dart';

class OnBoardingPickAccountIsReadySubmitSelector extends BlocSelector<
    OnBoardingPickAccountBloc, OnBoardingPickAccountState, bool> {
  OnBoardingPickAccountIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          builder: (_, isReady) => builder(isReady),
          key: key,
          selector: (state) => state.isReadySubmit,
        );
}

class OnBoardingPickAccountAccountNameSelector extends BlocSelector<
    OnBoardingPickAccountBloc, OnBoardingPickAccountState, String> {
  OnBoardingPickAccountAccountNameSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          builder: (_, accountName) => builder(accountName),
          key: key,
          selector: (state) => state.accountName,
        );
}
