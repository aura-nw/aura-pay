import 'package:flutter/material.dart';
import 'package:pyxis_v2/app_configs/di.dart' as di;
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/pyxis_application.dart';
import 'package:wallet_core/wallet_core.dart';

// Change this one if you want to change environment
const PyxisEnvironment environment = PyxisEnvironment.serenity;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.initDependency(
    PyxisMobileConfig(
      configs: {},
      environment: environment,
    ),
  );

  // Load language
  await AppLocalizationManager.instance.load();

  FlutterTrustWalletCore.init();

  runApp(
    const PyxisApplication(),
  );
}
