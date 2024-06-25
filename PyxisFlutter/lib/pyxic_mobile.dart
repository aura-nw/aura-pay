import 'package:domain/domain.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/address_book/address_book_db.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/bookmark/bookmark_db.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/browser/browser_db.dart';
import 'package:pyxis_mobile/src/core/constants/aura_scan.dart';
import 'src/application/global/localization/localization_manager.dart';
import 'app_configs/pyxis_mobile_config.dart';
import 'package:flutter/material.dart';
import 'app_configs/di.dart' as di;
import 'src/application/provider/local_database/aura_account/aura_account_db.dart';
import 'src/aura_wallet_application.dart';
import 'src/core/constants/app_local_constant.dart';
import 'dart:developer' as developer;

import 'src/core/constants/aura_ecosystem.dart';

/// Starts the Pyxis Mobile application.
///
/// This method initializes the Isar database, initializes the dependency injection,
/// and loads the application localization. Finally, it runs the `AuraWalletApplication`.
///
/// Parameters:
/// - `config`: The PyxisMobileConfig object containing the configuration for the application.
void start(PyxisMobileConfig config) async {
  // Get the path to the application documents directory
  final path = (await getApplicationDocumentsDirectory()).path;

  LogProvider.init(LogProviderImpl());

  late Isar isar;
  if (Isar.instanceNames.isEmpty) {
    // Open the Isar database with the specified schema, directory, name, and maximum size
    isar = await Isar.open(
      [
        AuraAccountDbSchema,
        BrowserDbSchema,
        BookMarkDbSchema,
        AddressBookDbSchema,
      ],
      directory: path,
      name: AppLocalConstant.accountDbName,
      maxSizeMiB: 128,
    );
  } else {
    // Get the existing instance of the Isar database
    isar = Isar.getInstance(AppLocalConstant.accountDbName)!;
  }

  // Initialize the dependency injection with the provided configuration and Isar database
  await di.initDependency(
    config,
    isar,
  );

  // Load the application localization
  await AppLocalizationManager.instance.load();

  // Call this to detect aura domain. It supports for app launcher
  AuraScan.init(config.environment);

  // Call this to detect aura ecosystems. It supports for in app browser
  AuraEcosystem.init(config.environment);

  // Run the AuraWalletApplication
  runApp(const AuraWalletApplication());
}

class LogProviderImpl implements LogProvider {
  @override
  void printLog(String message) {
    developer.log(message, name: 'pyxis_mobile');
  }
}
