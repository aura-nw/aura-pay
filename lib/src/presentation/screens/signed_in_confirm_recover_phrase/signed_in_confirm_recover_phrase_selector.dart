import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signed_in_confirm_recover_phrase_bloc.dart';
import 'signed_in_confirm_recover_phrase_state.dart';

class SignedInConfirmRecoverPhraseWalletNameSelector extends BlocSelector<
    SignedInConfirmRecoverPhraseBloc,
    SignedInConfirmRecoverPhraseState,
    String> {
  SignedInConfirmRecoverPhraseWalletNameSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          key: key,
          selector: (state) => state.walletName,
          builder: (_, walletName) => builder(walletName),
        );
}

class SignedInConfirmRecoverPhraseIsReadyConfirmSelector extends BlocSelector<
    SignedInConfirmRecoverPhraseBloc,
    SignedInConfirmRecoverPhraseState,
    bool> {
  SignedInConfirmRecoverPhraseIsReadyConfirmSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.isReadyConfirm,
          builder: (_, isReadyConfirm) => builder(isReadyConfirm),
        );
}
