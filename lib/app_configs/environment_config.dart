import 'package:aurapay/app_configs/aura_pay_config.dart';

/// Environment configuration class để quản lý environments
/// Sử dụng Dart-define để set environment tại build time
/// 
/// Usage:
/// ```bash
/// # Development
/// flutter run --dart-define=ENV=development
/// 
/// # Staging  
/// flutter run --dart-define=ENV=staging
/// 
/// # Production
/// flutter run --dart-define=ENV=production
/// ```
class EnvironmentConfig {
  /// Get environment từ compile-time constant
  /// Default là development nếu không được set
  static const String _envString = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// Get current environment
  static AuraPayEnvironment get environment {
    switch (_envString.toLowerCase()) {
      case 'production':
        return AuraPayEnvironment.production;
      case 'staging':
        return AuraPayEnvironment.staging;
      case 'development':
      case 'dev':
      case 'serenity':
        return AuraPayEnvironment.serenity;
      default:
        // Fallback to development nếu có giá trị không hợp lệ
        return AuraPayEnvironment.serenity;
    }
  }

  /// Check nếu đang ở production
  static bool get isProduction => environment == AuraPayEnvironment.production;

  /// Check nếu đang ở staging
  static bool get isStaging => environment == AuraPayEnvironment.staging;

  /// Check nếu đang ở development
  static bool get isDevelopment => environment == AuraPayEnvironment.serenity;

  /// Get environment name as string
  static String get environmentName => _envString;

  /// Print environment info (for debugging)
  static void printEnvironmentInfo() {
    final info = [
      '================================',
      'Environment Configuration',
      '================================',
      'Environment: $environmentName',
      'Is Production: $isProduction',
      'Is Staging: $isStaging',
      'Is Development: $isDevelopment',
      '================================',
    ].join('\n');
    
    // Use print for environment info as it's critical startup information
    // that should be visible in all build modes
    // ignore: avoid_print
    print(info);
  }
}

