import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/application/provider/smart_account/smart_account_provider_impl.dart';
import 'package:pyxis_mobile/src/application/service/balance/token_api_service_impl.dart';

/// Use for isolate

SmartAccountUseCase smartAccountUseCaseFactory(AuraSmartAccountEnvironment auraSmartAccountEnvironment) => SmartAccountUseCase(
      SmartAccountRepositoryImpl(
        SmartAccountProviderImpl(
          AuraSmartAccount.create(
            auraSmartAccountEnvironment,
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
