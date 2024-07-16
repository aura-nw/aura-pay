import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_v2/app_configs/di.dart' as di;
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/application/provider/local/account/account_db.dart';
import 'package:pyxis_v2/src/application/provider/local/balance/balance_db.dart';
import 'package:pyxis_v2/src/application/provider/local/key_store/key_store_db.dart';
import 'package:pyxis_v2/src/application/provider/local/token_market/token_market_db.dart';
import 'package:pyxis_v2/src/core/constants/app_local_constant.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/pyxis_application.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

// Change this one if you want to change environment
const PyxisEnvironment environment = PyxisEnvironment.staging;

class LogProviderImpl implements LogProvider {
  @override
  void printLog(String message) {
    developer.log(message, name: 'pyxis_mobile');
  }
}

Future<Map<String, dynamic>> _loadConfig() async {
  String loader;
  String path;

  switch (environment) {
    case PyxisEnvironment.serenity:
      path = AssetConfigPath.configDev;
      break;
    case PyxisEnvironment.staging:
      path = AssetConfigPath.configStaging;
      break;
    case PyxisEnvironment.production:
      path = AssetConfigPath.config;
      break;
  }
  try {
    loader = await rootBundle.loadString(
      path,
    );
  } catch (e) {
    loader = '';
    LogProvider.log('can\'t load config ${e.toString()}');
  }

  return jsonDecode(loader);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LogProvider.init(
    LogProviderImpl(),
  );

  final Map<String, dynamic> config = await _loadConfig();

  // Get the path to the application documents directory
  final path = (await getApplicationDocumentsDirectory()).path;

  late Isar isar;
  if (Isar.instanceNames.isEmpty) {
    // Open the Isar database with the specified schema, directory, name, and maximum size
    isar = await Isar.open(
      [
        AccountDbSchema,
        KeyStoreDbSchema,
        AccountBalanceDbSchema,
        TokenMarketDbSchema,
      ],
      directory: path,
      name: AppLocalConstant.localDbName,
      maxSizeMiB: 128,
    );
  } else {
    // Get the existing instance of the Isar database
    isar = Isar.getInstance(AppLocalConstant.localDbName)!;
  }

  // Init dependencies
  await di.initDependency(
    PyxisMobileConfig(
      configs: config,
      environment: environment,
    ),
    isar,
  );

  // Load language
  await AppLocalizationManager.instance.load();

  FlutterTrustWalletCore.init();

  runApp(
    const PyxisApplication(),
  );
}
