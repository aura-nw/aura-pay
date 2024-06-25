import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signed_in_create_eoa_by_google_pick_name_bloc.dart';
import 'signed_in_create_eoa_by_google_pick_name_state.dart';

class SignedInCreateEOAByGooglePickNameWalletNameSelector
    extends BlocSelector<SignedInCreateEOAByGooglePickNameBloc,
        SignedInCreateEOAByGooglePickNameState, String> {
  SignedInCreateEOAByGooglePickNameWalletNameSelector({
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

class SignedInCreateEOAByGooglePickNameIsReadyConfirmSelector
    extends BlocSelector<SignedInCreateEOAByGooglePickNameBloc,
        SignedInCreateEOAByGooglePickNameState, bool> {
  SignedInCreateEOAByGooglePickNameIsReadyConfirmSelector({
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
