import 'dart:convert';

enum Environment {
  dev,
  staging,
  production,
}

class PyxisMobileConfig {
  final Map<String, dynamic> configs;
  PyxisMobileConfig({required this.configs});

  Map<String, dynamic> get appConfigs => jsonDecode(configs['APP_CONFIG']);

  String get horoScopeUrl => configs['horoScope'];

  String get coinId => configs['coinId'];
  String get chainId => configs['chainId'];
  String get apiVersion => appConfigs['api_version'];
  String get deNom => configs['denom'];
  String get symbol => configs['coin'];
  String get baseUrl => configs['BASE_URL'];

  String get appName => configs['APP_NAME'];
}
