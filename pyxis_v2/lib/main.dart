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
import 'package:pyxis_v2/src/application/provider/local/token/token_db.dart';
import 'package:pyxis_v2/src/application/provider/local/token_market/token_market_db.dart';
import 'package:pyxis_v2/src/core/constants/app_local_constant.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/aura_scan.dart';
import 'package:pyxis_v2/src/pyxis_application.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

// Define the current environment for the application.
// Change this constant to switch between different environments.
const PyxisEnvironment environment = PyxisEnvironment.staging;

// Implementation of the LogProvider interface for handling log messages.
class LogProviderImpl implements LogProvider {
  @override
  void printLog(String message) {
    // Use the developer log to print messages with a specific tag.
    developer.log(message, name: 'pyxis_mobile');
  }
}

// Load configuration settings based on the current environment.
Future<Map<String, dynamic>> _loadConfig() async {
  String loader;
  String path;

  // Determine the path to the configuration file based on the environment.
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
    // Load the configuration file as a string.
    loader = await rootBundle.loadString(
      path,
    );
  } catch (e) {
    loader = '';
    // Handle errors in loading the configuration file.
    LogProvider.log('can\'t load config ${e.toString()}');
  }

  // Parse the loaded configuration file as JSON and return it.
  return jsonDecode(loader);
}

// Save a specific token in the local database if it doesn't already exist.
Future<void> _saveAuraToken(String name, String symbol) async {
  // Get the TokenUseCase instance for interacting with tokens.
  final TokenUseCase tokenUseCase = di.getIt.get<TokenUseCase>();

  // Check if the token with the specified name already exists.
  final nativeAura = await tokenUseCase.getByName(
    name: name,
  );

  // If the token does not exist, add it to the database.
  if (nativeAura == null) {
    await tokenUseCase.add(
      AddTokenRequest(
        logo: AppLocalConstant.auraLogo,
        tokenName: name,
        type: TokenType.native,
        symbol: symbol,
        contractAddress: '',
        isEnable: true,
      ),
    );
  }
}

void main() async {
  // Ensure that widget binding is initialized before any asynchronous operations.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logging system.
  LogProvider.init(
    LogProviderImpl(),
  );

  // Initialize the AuraScan library with the current environment.
  AuraScan.init(environment);

  // Load the application configuration.
  final Map<String, dynamic> config = await _loadConfig();

  // Get the path to the application's documents directory for storing data.
  final path = (await getApplicationDocumentsDirectory()).path;

  late Isar isar;
  // Check if the Isar database instance already exists.
  if (Isar.instanceNames.isEmpty) {
    // Open the Isar database with the specified schema, directory, name, and maximum size
    isar = await Isar.open(
      [
        AccountDbSchema,
        KeyStoreDbSchema,
        AccountBalanceDbSchema,
        TokenMarketDbSchema,
        TokenDbSchema,
      ],
      directory: path,
      name: AppLocalConstant.localDbName,
      maxSizeMiB: 128,
    );
  } else {
    // Get the existing instance of the Isar database
    isar = Isar.getInstance(AppLocalConstant.localDbName)!;
  }

  // Initialize the application's configuration and dependencies.
  final pickWalletConfig = PyxisMobileConfig(
    configs: config,
    environment: environment,
  );

  // Init dependencies
  await di.initDependency(
    pickWalletConfig,
    isar,
  );

  // Save the Aura token in the local database.
  await _saveAuraToken(
    pickWalletConfig.config.nativeCoin.name,
    pickWalletConfig.config.nativeCoin.symbol,
  );

  // Load localization settings for the application.
  await AppLocalizationManager.instance.load();

  // Initialize the Trust Wallet Core for blockchain interactions.
  FlutterTrustWalletCore.init();

  runApp(
    const PyxisApplication(),
  );
}
