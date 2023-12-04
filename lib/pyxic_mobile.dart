import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'src/application/global/localization/localization_manager.dart';
import 'app_configs/pyxis_mobile_config.dart';
import 'package:flutter/material.dart';
import 'app_configs/di.dart' as di;
import 'src/aura_wallet_application.dart';
import 'src/core/constants/app_local_constant.dart';

void start(PyxisMobileConfig config) async {
  final path = (await getApplicationDocumentsDirectory()).path;

  late Isar isar;
  if (Isar.instanceNames.isEmpty) {
    isar = await Isar.open(
      [
        AuraAccountDtoSchema,
      ],
      directory: path,
      name: AppLocalConstant.accountDbName,
      maxSizeMiB: 128,
    );
  } else {
    isar = Isar.getInstance()!;
  }

  await di.initDependency(
    config,
    isar,
  );
  await AppLocalizationManager.instance.load();

  runApp(const AuraWalletApplication());
}
