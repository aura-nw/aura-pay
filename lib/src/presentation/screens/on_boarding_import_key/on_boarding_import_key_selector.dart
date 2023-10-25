import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'on_boarding_import_key_state.dart';
import 'on_boarding_import_key_bloc.dart';

class OnBoardingImportKeyIsReadySubmitSelector extends BlocSelector<
    OnBoardingImportKeyBloc, OnBoardingImportKeyState, bool> {
  OnBoardingImportKeyIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          builder: (_, isReady) => builder(isReady),
          selector: (state) => state.isReadySubmit,
        );
}

class OnBoardingImportKeyAccountTypeSelector extends BlocSelector<
    OnBoardingImportKeyBloc, OnBoardingImportKeyState, PyxisWalletType> {
  OnBoardingImportKeyAccountTypeSelector({
    Key? key,
    required Widget Function(PyxisWalletType) builder,
  }) : super(
          key: key,
          builder: (_, accountType) => builder(accountType),
          selector: (state) => state.pyxisWalletType,
        );
}

class OnBoardingImportKeyImportTypeSelector extends BlocSelector<
    OnBoardingImportKeyBloc, OnBoardingImportKeyState, ImportWalletType> {
  OnBoardingImportKeyImportTypeSelector({
    Key? key,
    required Widget Function(ImportWalletType) builder,
  }) : super(
          key: key,
          builder: (_, importWalletType) => builder(importWalletType),
          selector: (state) => state.importWalletType,
        );
}
