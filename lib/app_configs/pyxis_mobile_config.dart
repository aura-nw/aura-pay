import 'dart:convert';

enum Environment {
  dev,
  serenity,
  staging,
  production,
}

class PyxisMobileConfig {
  final Map<String, dynamic> configs;
  PyxisMobileConfig({required this.configs});

  Map<String, dynamic> get appConfigs => jsonDecode(configs['APP_CONFIG']);

  String get coinId => appConfigs['coinId'];
  String get chainId => appConfigs['chainId'];
  String get deNom => appConfigs['denom'];
  String get symbol => appConfigs['coin'];
  String get lcdUrl => configs['LCD_URL'];

  String get appName => configs['APP_NAME'];
  String get web3AuthClientId => configs['WEB3_AUTH_CLIENT_ID'];
}
