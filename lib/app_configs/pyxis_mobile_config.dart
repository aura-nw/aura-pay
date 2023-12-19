import 'dart:convert';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/config_options/environment_options.dart';

extension PyxisEnvironmentMapper on PyxisEnvironment {
  AuraSmartAccountEnvironment get toSME {
    int index = this.index;

    return AuraSmartAccountEnvironment.values[index];
  }
  AuraEnvironment get toWalletCoreE  {
    int index = this.index;

    return AuraEnvironment.values[index];
  }
}

enum PyxisEnvironment {
  dev,
  serenity,
  staging,
  production,
}

class PyxisMobileConfig {
  final Map<String, dynamic> configs;
  final PyxisEnvironment environment;

  PyxisMobileConfig({
    required this.configs,
    this.environment = PyxisEnvironment.dev,
  });

  Map<String, dynamic> get appConfigs => jsonDecode(configs['APP_CONFIG']);

  Map<String, dynamic> get coinGECKO => jsonDecode(configs['COIN_GECKO']);

  String get coinGeckoUrl => coinGECKO['base_url'];

  String get coinGeckoVersion => coinGECKO['api_version'];

  String get auraId => configs['AURA_ID'];

  String get coinId => appConfigs['coinId'];

  String get chainId => appConfigs['chainId'];

  String get deNom => appConfigs['denom'];

  String get symbol => appConfigs['coin'];

  String get lcdUrl => configs['LCD_URL'];

  String get appName => configs['APP_NAME'];

  String get web3AuthClientId => configs['WEB3_AUTH_CLIENT_ID'];
}
