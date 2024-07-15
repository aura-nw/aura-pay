import 'dart:io';
import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_v2/src/application/provider/local/account/account_database_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/local/key_store/key_store_database_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/local/localization_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/local/normal_storage_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/local/secure_storage_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/local/token_market/token_market_database_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/provider/biometric_provider.dart';
import 'package:pyxis_v2/src/application/provider/provider/web3_auth_provider.dart';
import 'package:pyxis_v2/src/application/provider/service/token_market/remote_token_market_service_impl.dart';
import 'package:pyxis_v2/src/core/constants/app_local_constant.dart';
import 'package:pyxis_v2/src/presentation/screens/create_passcode/create_passcode_cubit.dart';
import 'package:pyxis_v2/src/presentation/screens/generate_wallet/generate_wallet_cubit.dart';
import 'package:pyxis_v2/src/presentation/screens/get_started/get_started_cubit.dart';
import 'package:pyxis_v2/src/presentation/screens/import_wallet/import_wallet_bloc.dart';
import 'package:pyxis_v2/src/presentation/screens/import_wallet_yeti_bot/import_wallet_yeti_bot_cubit.dart';
import 'package:pyxis_v2/src/presentation/screens/re_login/re_login_cubit.dart';
import 'package:pyxis_v2/src/presentation/screens/social_login_yeti_bot/social_login_yeti_bot_cubit.dart';
import 'package:pyxis_v2/src/presentation/screens/splash/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'pyxis_mobile_config.dart';

final getIt = GetIt.instance;

Future<void> initDependency(
  PyxisMobileConfig config,
  Isar isar,
) async {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: config.config.api.v2.url,
      connectTimeout: const Duration(
        milliseconds: 60000,
      ),
      receiveTimeout: const Duration(
        milliseconds: 60000,
      ),
      contentType: 'application/json; charset=utf-8',
    ),
  );

  getIt.registerLazySingleton<PyxisMobileConfig>(
    () => config,
  );

  getIt.registerFactory<Dio>(
    () => dio,
  );

  WalletCore.init();

  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: AppLocalConstant.secureStorageName,
      preferencesKeyPrefix: AppLocalConstant.secureStoragePrefix,
    ),
    iOptions: IOSOptions(),
  );

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // Set web3 auth redirect uri
  // Must replace late
  Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse(config.config.web3Auth.androidRedirectUrl);
  } else {
    redirectUrl = Uri.parse(config.config.web3Auth.iosRedirectUrl);
  }

  await Web3AuthFlutter.init(
    Web3AuthOptions(
      clientId: config.config.web3Auth.clientId,
      network: Network.sapphire_devnet,
      redirectUrl: redirectUrl,
    ),
  );

  // Register generator
  getIt.registerLazySingleton<RemoteTokenMarketServiceGenerator>(
    () => RemoteTokenMarketServiceGenerator(
      getIt.get<Dio>(),
    ),
  );

  // Register service
  getIt.registerLazySingleton<LocalizationService>(
    () => LocalizationServiceImpl(),
  );

  getIt.registerLazySingleton<BiometricProvider>(
    () => BiometricProviderImpl(),
  );

  getIt.registerLazySingleton<NormalStorageService>(
    () => NormalStorageServiceImpl(sharedPreferences),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => const SecureStorageServiceImpl(secureStorage),
  );

  getIt.registerLazySingleton<AccountDatabaseService>(
    () => AccountDatabaseServiceImpl(
      isar,
    ),
  );

  getIt.registerLazySingleton<KeyStoreDatabaseService>(
    () => KeyStoreDatabaseServiceImpl(
      isar,
    ),
  );

  getIt.registerLazySingleton<TokenMarketDatabaseService>(
    () => TokenMarketDatabaseServiceImpl(
      isar,
    ),
  );

  getIt.registerLazySingleton<RemoteTokenMarketService>(
    () => RemoteTokenMarketServiceImpl(
      getIt.get<RemoteTokenMarketServiceGenerator>(),
    ),
  );

  getIt.registerLazySingleton<Web3AuthProvider>(
    () => const Web3AuthProviderImpl(),
  );

  // Register repository
  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(
      getIt.get<LocalizationService>(),
    ),
  );

  getIt.registerLazySingleton<AppSecureRepository>(
    () => AppSecureRepositoryImpl(
      getIt.get<NormalStorageService>(),
      getIt.get<BiometricProvider>(),
    ),
  );

  getIt.registerLazySingleton<KeyStoreRepository>(
    () => KeyStoreRepositoryImpl(
      getIt.get<KeyStoreDatabaseService>(),
    ),
  );

  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      getIt.get<AccountDatabaseService>(),
    ),
  );

  getIt.registerLazySingleton<Web3AuthRepository>(
    () => Web3AuthRepositoryImpl(
      getIt.get<Web3AuthProvider>(),
    ),
  );

  getIt.registerLazySingleton<TokenMarketRepository>(
    () => TokenMarketRepositoryImpl(
      getIt.get<RemoteTokenMarketServiceImpl>(),
      getIt.get<TokenMarketDatabaseService>(),
    ),
  );

  // Register use case
  getIt.registerLazySingleton<LocalizationUseCase>(
    () => LocalizationUseCase(
      getIt.get<LocalizationRepository>(),
    ),
  );

  getIt.registerLazySingleton<AppSecureUseCase>(
    () => AppSecureUseCase(
      getIt.get<AppSecureRepository>(),
    ),
  );

  getIt.registerLazySingleton<KeyStoreUseCase>(
    () => KeyStoreUseCase(
      getIt.get<KeyStoreRepository>(),
    ),
  );

  getIt.registerLazySingleton<AccountUseCase>(
    () => AccountUseCase(
      getIt.get<AccountRepository>(),
    ),
  );

  getIt.registerLazySingleton<Web3AuthUseCase>(
    () => Web3AuthUseCase(
      getIt.get<Web3AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<TokenMarketUseCase>(
    () => TokenMarketUseCase(
      getIt.get<TokenMarketRepository>(),
    ),
  );

  // Register bloc
  getIt.registerFactory<CreatePasscodeCubit>(
    () => CreatePasscodeCubit(
      getIt.get<AppSecureUseCase>(),
    ),
  );

  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(
      getIt.get(),
      getIt.get(),
    ),
  );

  getIt.registerFactory<GenerateWalletCubit>(
    () => GenerateWalletCubit(
      getIt.get<AccountUseCase>(),
      getIt.get<KeyStoreUseCase>(),
    ),
  );

  getIt.registerFactory<ReLoginCubit>(
    () => ReLoginCubit(
      getIt.get<AppSecureUseCase>(),
      getIt.get<AccountUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => ImportWalletBloc(),
  );

  getIt.registerFactoryParam<ImportWalletYetiBotCubit, AWallet, dynamic>(
    (wallet, _) => ImportWalletYetiBotCubit(
      getIt.get<AccountUseCase>(),
      getIt.get<KeyStoreUseCase>(),
      wallet: wallet,
    ),
  );

  getIt.registerFactory<GetStartedCubit>(
    () => GetStartedCubit(
      getIt.get<Web3AuthUseCase>(),
    ),
  );

  getIt.registerFactoryParam<SocialLoginYetiBotCubit, AWallet, dynamic>(
    (wallet, _) => SocialLoginYetiBotCubit(
      getIt.get<AccountUseCase>(),
      getIt.get<KeyStoreUseCase>(),
      wallet: wallet,
    ),
  );
}
