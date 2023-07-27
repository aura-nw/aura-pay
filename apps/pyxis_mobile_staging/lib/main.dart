import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/pyxic_mobile.dart';

class PyxisMobileStagingConfig implements PyxisMobileConfig {
  PyxisMobileStagingConfig({
    required this.baseUrl,
    this.configs,
    this.environment = Environment.dev,
  });

  @override
  String baseUrl;

  @override
  Map<String, dynamic>? configs;

  @override
  Environment environment;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env');

  final PyxisMobileConfig config = PyxisMobileStagingConfig(
    baseUrl: dotenv.env.baseUrl,
    configs: dotenv.env.configs,
  );

  start(config);
}