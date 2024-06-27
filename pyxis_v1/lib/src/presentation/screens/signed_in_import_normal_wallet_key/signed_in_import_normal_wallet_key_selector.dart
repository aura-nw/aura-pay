import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'signed_in_import_normal_wallet_key_bloc.dart';
import 'signed_in_import_normal_wallet_key_state.dart';

class SignedInImportNormalWalletKeyIsReadySubmitSelector extends BlocSelector<
    SignedInImportNormalWalletKeyBloc, SignedInImportNormalWalletKeyState, bool> {
  SignedInImportNormalWalletKeyIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          builder: (_, isReady) => builder(isReady),
          selector: (state) => state.isReadySubmit,
        );
}

class SignedInImportNormalWalletKeyShowPrivateKeySelector extends BlocSelector<
    SignedInImportNormalWalletKeyBloc, SignedInImportNormalWalletKeyState, bool> {
  SignedInImportNormalWalletKeyShowPrivateKeySelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          builder: (_, showPrivateKey) => builder(showPrivateKey),
          selector: (state) => state.showPrivateKey,
        );
}

class SignedInImportNormalWalletKeyImportTypeSelector extends BlocSelector<
    SignedInImportNormalWalletKeyBloc, SignedInImportNormalWalletKeyState, ImportWalletType> {
  SignedInImportNormalWalletKeyImportTypeSelector({
    Key? key,
    required Widget Function(ImportWalletType) builder,
  }) : super(
          key: key,
          builder: (_, importWalletType) => builder(importWalletType),
          selector: (state) => state.importWalletType,
        );
}
