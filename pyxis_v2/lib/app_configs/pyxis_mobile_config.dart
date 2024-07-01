import 'dart:convert';

enum PyxisEnvironment {
  serenity,
  staging,
  production,
}

class PyxisMobileConfig {
  final Map<String, dynamic> configs;
  final PyxisEnvironment environment;

  PyxisMobileConfig({
    required this.configs,
    this.environment = PyxisEnvironment.serenity,
  });

  Map<String, dynamic> get appConfigs => jsonDecode(configs['APP_CONFIG']);

  String get auraId => configs['AURA_ID'];

  String get chainName => appConfigs['chainName'];

  String get coinId => appConfigs['coinId'];

  String get chainId => appConfigs['chainId'];

  String get deNom => appConfigs['denom'];

  String get symbol => appConfigs['coin'];

  String get appName => configs['APP_NAME'];

  String get web3AuthClientId => configs['WEB3_AUTH_CLIENT_ID'];
  String get web3AuthAndroidRedirectUrl => configs['WEB3_AUTH_ANDROID_REDIRECT_URL'];
  String get web3AuthIOSRedirectUrl => configs['WEB3_AUTH_IOS_REDIRECT_URL'];
}
