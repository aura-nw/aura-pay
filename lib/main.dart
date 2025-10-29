import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallet_core/wallet_core.dart';

import 'package:aurapay/app_configs/di.dart' as di;
import 'package:aurapay/app_configs/aura_pay_config.dart';
import 'package:aurapay/app_configs/config_loader.dart';
import 'package:aurapay/app_configs/environment_config.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/application/provider/local/account/account_db.dart';
import 'package:aurapay/src/application/provider/local/balance/balance_db.dart';
import 'package:aurapay/src/application/provider/local/key_store/key_store_db.dart';
import 'package:aurapay/src/application/provider/local/token/token_db.dart';
import 'package:aurapay/src/application/provider/local/token_market/token_market_db.dart';
import 'package:aurapay/src/application/provider/provider/log_provider_impl.dart';
import 'package:aurapay/src/core/constants/app_local_constant.dart';
import 'package:aurapay/src/core/constants/aura_scan.dart';
import 'package:aurapay/src/aura_pay_application.dart';

/// Entry point of the AuraPay application.
/// 
/// Initializes all necessary services and configurations before
/// starting the Flutter application.
void main() async {
  // Ensure Flutter binding is initialized for async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging provider for application-wide logging
  LogProvider.init(LogProviderImpl());

  // Get current environment (development/staging/production)
  final environment = EnvironmentConfig.environment;
  EnvironmentConfig.printEnvironmentInfo();

  // Initialize AuraScan configuration based on environment
  AuraScan.init(environment);

  // Load application configuration from assets
  final config = await ConfigLoader.loadConfig(environment);

  // Initialize local database (Isar)
  final isar = await _initializeDatabase();

  // Create application configuration
  final auraPayConfig = AuraPayConfig(
    configs: config,
    environment: environment,
  );

  // Initialize dependency injection
  await di.initDependency(auraPayConfig, isar);

  // Ensure native token (AURA) is saved in database on first launch
  await _saveAuraToken(
    auraPayConfig.config.nativeCoin.name,
    auraPayConfig.config.nativeCoin.symbol,
  );

  // Load localization/language resources
  await AppLocalizationManager.instance.load();

  // Initialize Trust Wallet Core for crypto operations
  FlutterTrustWalletCore.init();

  // Start the application
  runApp(const AuraPayApplication());
}

/// Initializes the Isar database with all required schemas.
/// 
/// Returns existing instance if already initialized, otherwise creates a new one.
Future<Isar> _initializeDatabase() async {
  final path = (await getApplicationDocumentsDirectory()).path;

  if (Isar.instanceNames.isEmpty) {
    // Create new Isar instance with all schemas
    return await Isar.open(
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
    // Return existing Isar instance
    return Isar.getInstance(AppLocalConstant.localDbName)!;
  }
}

/// Saves the native AURA token to the database if it doesn't exist.
/// 
/// This ensures the native token is always available in the token list
/// when the app first launches.
Future<void> _saveAuraToken(String name, String symbol) async {
  final tokenUseCase = di.getIt.get<TokenUseCase>();
  final existingToken = await tokenUseCase.getByName(name: name);

  // Only add if token doesn't exist
  if (existingToken == null) {
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
