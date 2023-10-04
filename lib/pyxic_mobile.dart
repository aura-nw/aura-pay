import 'src/application/global/localization/localization_manager.dart';
import 'app_configs/pyxis_mobile_config.dart';
import 'package:flutter/material.dart';
import 'app_configs/di.dart' as di;
import 'src/aura_wallet_application.dart';

void start(PyxisMobileConfig config) async {
  await AppLocalizationManager.instance.load();

  await di.initDependency(config);

  runApp(const AuraWalletApplication());
}