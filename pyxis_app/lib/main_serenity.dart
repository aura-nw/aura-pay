import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/pyxic_mobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env.serenity');

  final PyxisMobileConfig config = PyxisMobileConfig(
    configs: {}..addAll(dotenv.env),
    environment: PyxisEnvironment.serenity,
  );

  start(config);
}
