import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_confirm_recover_phrase_bloc.dart';
import 'on_boarding_confirm_recover_phrase_state.dart';

class OnBoardingConfirmRecoverPhraseWalletNameSelector extends BlocSelector<
    OnBoardingConfirmRecoverPhraseBloc,
    OnBoardingConfirmRecoverPhraseState,
    String> {
  OnBoardingConfirmRecoverPhraseWalletNameSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          key: key,
          selector: (state) => state.walletName,
          builder: (_, walletName) => builder(walletName),
        );
}

class OnBoardingConfirmRecoverPhraseIsReadyConfirmSelector extends BlocSelector<
    OnBoardingConfirmRecoverPhraseBloc,
    OnBoardingConfirmRecoverPhraseState,
    bool> {
  OnBoardingConfirmRecoverPhraseIsReadyConfirmSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.isReadyConfirm,
          builder: (_, isReadyConfirm) => builder(isReadyConfirm),
        );
}
