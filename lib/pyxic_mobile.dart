import 'package:aura_sdk/aura_sdk.dart';

import 'src/application/wrappers/localization/localization_manager.dart';
import 'app_configs/pyxis_mobile_config.dart';
import 'package:flutter/material.dart';
import 'app_configs/di.dart' as di;
import 'src/aura_wallet_application.dart';

void start(PyxisMobileConfig config) async {
  await AppLocalizationManager.instance.load();

  AuraSDK.init(
    'Pyxis Mobile',
    '',
    '',
    environment: config.environment == Environment.dev
        ? AuraWalletEnvironment.testNet
        : config.environment == Environment.staging
            ? AuraWalletEnvironment.euphoria
            : AuraWalletEnvironment.mainNet,
  );
  await di.initDependency(config);

  runApp(const AuraWalletApplication());
}