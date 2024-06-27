import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_create_eoa_by_google_pick_name_bloc.dart';
import 'on_boarding_create_eoa_by_google_pick_name_state.dart';

class OnBoardingCreateEOAByGooglePickNameWalletNameSelector
    extends BlocSelector<OnBoardingCreateEOAByGooglePickNameBloc,
        OnBoardingCreateEOAByGooglePickNameState, String> {
  OnBoardingCreateEOAByGooglePickNameWalletNameSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          key: key,
          selector: (state) => state.walletName,
          builder: (_, walletName) => builder(
            walletName,
          ),
        );
}

class OnBoardingCreateEOAByGooglePickNameIsReadyConfirmSelector
    extends BlocSelector<OnBoardingCreateEOAByGooglePickNameBloc,
        OnBoardingCreateEOAByGooglePickNameState, bool> {
  OnBoardingCreateEOAByGooglePickNameIsReadyConfirmSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.isReadyConfirm,
          builder: (_, isReadyConfirm) => builder(
            isReadyConfirm,
          ),
        );
}
