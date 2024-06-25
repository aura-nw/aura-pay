import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/pyxic_mobile.dart';

/// The environment to use
PyxisEnvironment selectedEnvironment =
    PyxisEnvironment.staging; // The environment

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment configuration
  switch (selectedEnvironment) {
    case PyxisEnvironment.dev:
      await dotenv.load(fileName: 'assets/.env.dev');
      break;
    case PyxisEnvironment.serenity:
      await dotenv.load(fileName: 'assets/.env.serenity');
      break;
    case PyxisEnvironment.staging:
      await dotenv.load(fileName: 'assets/.env.euphoria');
      break;
    case PyxisEnvironment.production:
      await dotenv.load(fileName: 'assets/.env.prod');
  }

  // Create the PyxisMobileConfig object with the environment configuration
  final PyxisMobileConfig config = PyxisMobileConfig(
    configs: {}..addAll(dotenv.env),
    environment: selectedEnvironment,
  );

  // Start the Pyxis Mobile application
  start(config);
}
