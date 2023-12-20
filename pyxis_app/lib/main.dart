import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/pyxic_mobile.dart';

/// The environment to use
Environment selectedEnvironment = Environment.dev; // The environment

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment configuration
  switch (selectedEnvironment) {
    case Environment.dev:
      await dotenv.load(fileName: 'assets/.env.dev');
      break;
    case Environment.serenity:
      await dotenv.load(fileName: 'assets/.env.serenity');
      break;
    case Environment.staging:
      await dotenv.load(fileName: 'assets/.env.staging');
      break;
    case Environment.prod:
      await dotenv.load(fileName: 'assets/.env.prod');
  }

  // Create the PyxisMobileConfig object with the environment configuration
  final PyxisMobileConfig config = PyxisMobileConfig(
    configs: {}..addAll(dotenv.env),
  );

  // Start the Pyxis Mobile application
  start(config);
}

enum Environment {
  dev,
  serenity,
  staging,
  prod,
}
