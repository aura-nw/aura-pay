import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

import 'signed_in_import_key_bloc.dart';
import 'signed_in_import_key_state.dart';

class SignedInImportKeyIsReadySubmitSelector extends BlocSelector<
    SignedInImportKeyBloc, SignedInImportKeyState, bool> {
  SignedInImportKeyIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          builder: (_, isReady) => builder(isReady),
          selector: (state) => state.isReadySubmit,
        );
}

class SignedInImportKeyAccountTypeSelector extends BlocSelector<
    SignedInImportKeyBloc, SignedInImportKeyState, PyxisWalletType> {
  SignedInImportKeyAccountTypeSelector({
    Key? key,
    required Widget Function(PyxisWalletType) builder,
  }) : super(
          key: key,
          builder: (_, accountType) => builder(accountType),
          selector: (state) => state.pyxisWalletType,
        );
}

class SignedInImportKeyImportTypeSelector extends BlocSelector<
    SignedInImportKeyBloc, SignedInImportKeyState, ImportWalletType> {
  SignedInImportKeyImportTypeSelector({
    Key? key,
    required Widget Function(ImportWalletType) builder,
  }) : super(
          key: key,
          builder: (_, importWalletType) => builder(importWalletType),
          selector: (state) => state.importWalletType,
        );
}
