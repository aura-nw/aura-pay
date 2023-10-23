import 'dart:convert';

// extension PyxisMobileConfigX on Map<String, dynamic> {
//   String get baseUrl => this['BASE_URL'];

//   Map<String, dynamic> get configs => jsonDecode(this['APP_CONFIG']);

//   String get horoScopeUrl => this['horoScope'];

//   String get coinId => this['coinId'];
//   String get chainId => this['chainId'];
//   String get apiVersion => this['api_version'];
//   String get deNom => this['denom'];
//   String get symbol => this['coin'];
// }

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
}
