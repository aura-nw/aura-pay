import 'dart:convert';

import 'package:aura_smart_account/aura_smart_account.dart';

extension PyxisEnvironmentMapper on PyxisEnvironment {
  String get environmentString {
    switch (this) {
      case PyxisEnvironment.dev:
        return 'auratestnet';
      case PyxisEnvironment.serenity:
        return 'serenity';
      case PyxisEnvironment.staging:
        return 'euphoria';
      case PyxisEnvironment.production:
        return 'xstaxy';
    }
  }

  AuraSmartAccountEnvironment get toSME {
    int index = this.index;

    return AuraSmartAccountEnvironment.values[index];
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

  Map<String, dynamic> get horoScopeConfig =>
      jsonDecode(configs['HORO_SCOPE_CONFIG']);

  Map<String, dynamic> get auraNetWorkConfig =>
      jsonDecode(configs['AURA_NET_WORK_CONFIG']);

  Map<String, dynamic> get hasuraNetworkConfig =>
      jsonDecode(configs['HASURA_NETWORK_CONFIG']);

  Map<String, dynamic> get pyxisNetworkConfig =>
      jsonDecode(configs['PYXIS_NETWORK_CONFIG']);

  String get hasuraBaseUrl => hasuraNetworkConfig['baseUrl'];

  String get hasuraVersion => hasuraNetworkConfig['version'];

  String get pyxisBaseUrl => pyxisNetworkConfig['baseUrl'];

  String get pyxisVersion => pyxisNetworkConfig['version'];

  String get horoScopeUrl => horoScopeConfig['baseUrl'];

  String get horoScopeVersion => horoScopeConfig['version'];

  String get auraNetworkBaseUrl => auraNetWorkConfig['baseUrl'];

  String get auraNetworkVersion => auraNetWorkConfig['version'];

  String get auraId => configs['AURA_ID'];

  String get chainName => appConfigs['chainName'];

  String get coinId => appConfigs['coinId'];

  String get chainId => appConfigs['chainId'];

  String get deNom => appConfigs['denom'];

  String get symbol => appConfigs['coin'];

  String get appName => configs['APP_NAME'];

  String get web3AuthClientId => configs['WEB3_AUTH_CLIENT_ID'];
}
