import 'dart:io';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_v2/src/application/provider/local/localization_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/local/normal_storage_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/local/secure_storage_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/provider/biometric_provider.dart';
import 'package:pyxis_v2/src/core/constants/app_local_constant.dart';
import 'package:pyxis_v2/src/presentation/screens/create_passcode/create_passcode_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'pyxis_mobile_config.dart';

final getIt = GetIt.instance;

Future<void> initDependency(
  PyxisMobileConfig config,
) async {
  // final Dio dio = Dio(
  //   BaseOptions(
  //     baseUrl: config.horoScopeUrl + config.horoScopeVersion,
  //     connectTimeout: const Duration(
  //       milliseconds: 60000,
  //     ),
  //     receiveTimeout: const Duration(
  //       milliseconds: 60000,
  //     ),
  //     contentType: 'application/json; charset=utf-8',
  //   ),
  // );

  WalletCore.init();

  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: AppLocalConstant.keyDbName,
      preferencesKeyPrefix: AppLocalConstant.keyDbPrefix,
    ),
    iOptions: IOSOptions(),
  );

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // Set web3 auth redirect uri
  // Must replace late
  Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse(config.web3AuthAndroidRedirectUrl);
  } else {
    redirectUrl = Uri.parse(config.web3AuthIOSRedirectUrl);
  }

  await Web3AuthFlutter.init(
    Web3AuthOptions(
      clientId: config.web3AuthClientId,
      network: Network.sapphire_devnet,
      redirectUrl: redirectUrl,
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

  // Register repository
  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(
      getIt.get<LocalizationService>(),
    ),
  );

  getIt.registerLazySingleton(
    () => AppSecureRepositoryImpl(
      getIt.get<NormalStorageService>(),
      getIt.get<BiometricProvider>(),
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

  // Register bloc
  getIt.registerFactory<CreatePasscodeCubit>(
    () => CreatePasscodeCubit(
      getIt.get<AppSecureUseCase>(),
    ),
  );
}
