import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:aurapay/app_configs/aura_pay_config.dart';
import 'package:aurapay/src/core/constants/asset_path.dart';

/// Service để load application configuration từ assets
/// dựa trên environment hiện tại
class ConfigLoader {
  const ConfigLoader._();

  /// Load config từ assets dựa trên environment
  /// 
  /// Returns parsed JSON config as Map
  /// Throws exception nếu không load được config
  static Future<Map<String, dynamic>> loadConfig(
    AuraPayEnvironment environment,
  ) async {
    final path = _getConfigPath(environment);

    try {
      final configString = await rootBundle.loadString(path);
      return jsonDecode(configString) as Map<String, dynamic>;
    } catch (e) {
      LogProvider.log('Failed to load config from $path: ${e.toString()}');
      // Return empty config để app có thể handle gracefully
      return {};
    }
  }

  /// Get config file path based on environment
  static String _getConfigPath(AuraPayEnvironment environment) {
    switch (environment) {
      case AuraPayEnvironment.serenity:
        return AssetConfigPath.configDev;
      case AuraPayEnvironment.staging:
        return AssetConfigPath.configStaging;
      case AuraPayEnvironment.production:
        return AssetConfigPath.config;
    }
  }
}

