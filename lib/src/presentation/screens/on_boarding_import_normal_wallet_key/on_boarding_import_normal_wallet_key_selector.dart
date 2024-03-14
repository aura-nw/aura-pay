import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'on_boarding_import_normal_wallet_key_bloc.dart';
import 'on_boarding_import_normal_wallet_key_state.dart';

class OnBoardingImportNormalWalletKeyIsReadySubmitSelector extends BlocSelector<
    OnBoardingImportNormalWalletKeyBloc, OnBoardingImportNormalWalletKeyState, bool> {
  OnBoardingImportNormalWalletKeyIsReadySubmitSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          builder: (_, isReady) => builder(isReady),
          selector: (state) => state.isReadySubmit,
        );
}

class OnBoardingImportNormalWalletKeyShowPrivateKeySelector extends BlocSelector<
    OnBoardingImportNormalWalletKeyBloc, OnBoardingImportNormalWalletKeyState, bool> {
  OnBoardingImportNormalWalletKeyShowPrivateKeySelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          builder: (_, showPrivateKey) => builder(showPrivateKey),
          selector: (state) => state.showPrivateKey,
        );
}

class OnBoardingImportNormalWalletKeyImportTypeSelector extends BlocSelector<
    OnBoardingImportNormalWalletKeyBloc, OnBoardingImportNormalWalletKeyState, ImportWalletType> {
  OnBoardingImportNormalWalletKeyImportTypeSelector({
    Key? key,
    required Widget Function(ImportWalletType) builder,
  }) : super(
          key: key,
          builder: (_, importWalletType) => builder(importWalletType),
          selector: (state) => state.importWalletType,
        );
}
