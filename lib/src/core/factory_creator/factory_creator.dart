import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/aura_account/aura_account_db.dart';
import 'package:pyxis_mobile/src/application/provider/smart_account/smart_account_provider_impl.dart';
import 'package:pyxis_mobile/src/application/service/balance/token_api_service_impl.dart';
import 'package:pyxis_mobile/src/application/service/smart_account/smart_account_api_service_impl.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';

/// Use for isolate

SmartAccountUseCase smartAccountUseCaseFactory(
  AuraSmartAccountEnvironment auraSmartAccountEnvironment,
  Dio dio,
  Isar isar,
) =>
    SmartAccountUseCase(
      SmartAccountRepositoryImpl(
        SmartAccountProviderImpl(
          AuraSmartAccount.create(
            auraSmartAccountEnvironment,
          ),
        ),
        SmartAccountApiServiceImpl(
          SmartAccountApiServiceGenerate(
            dio,
          ),
        ),
      ),
    );

BalanceUseCase balanceUseCaseFactory(Dio dio) => BalanceUseCase(
      BalanceRepositoryImpl(
        BalanceApiServiceImpl(
          BalanceApiServiceGenerator(
            dio,
          ),
        ),
      ),
    );

// Third party
Dio dioFactory(String baseUrl) => Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(
          milliseconds: 60000,
        ),
        receiveTimeout: const Duration(
          milliseconds: 60000,
        ),
        contentType: 'application/json; charset=utf-8',
      ),
    );

Future<Isar> getIsar() async {
  late Isar isar;
  if (Isar.instanceNames.isEmpty) {
    isar = await Isar.open(
      [
        AuraAccountDbSchema,
      ],
      directory: '',
      name: AppLocalConstant.accountDbName,
      maxSizeMiB: 128,
    );
  } else {
    isar = Isar.getInstance(
      AppLocalConstant.accountDbName,
    )!;
  }

  return isar;
}
