import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:aura_wallet_core/config_options/environment_options.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_import_key/on_boarding_import_key_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_pick_account/on_boarding_pick_account_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_re_login/on_boarding_re_login_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_choice/on_boarding_recover_choice_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_scan_fee/on_boarding_scan_fee_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_setup_passcode/on_boarding_setup_passcode_cubit.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction/send_transaction_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_new_sm_account_pick_account/signed_in_create_new_sm_account_pick_account_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_new_sm_account_scan_fee/signed_in_create_new_sm_account_scan_fee_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_import_key/signed_in_import_key_bloc.dart';

import 'pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initDependency(
  PyxisMobileConfig config,
  Isar isar,
) async {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl + config.apiVersion,
      connectTimeout: const Duration(
        milliseconds: 60000,
      ),
      receiveTimeout: const Duration(
        milliseconds: 60000,
      ),
      contentType: 'application/json; charset=utf-8',
    ),
  );

  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        sharedPreferencesName: AppLocalConstant.keyDbName),
    iOptions: IOSOptions(),
  );

  final GoogleSignIn googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
  );

  final AuraWalletCore coreWallet = AuraWalletCore.create(
    environment: AuraEnvironment.testNet,
  );

  final AuraSmartAccount auraSmartAccount = AuraSmartAccount.create(
    AuraSmartAccountEnvironment.test,
  );

  getIt.registerFactory<Dio>(
    () => dio,
  );

  getIt.registerLazySingleton<PyxisMobileConfig>(
    () => config,
  );

  ///Api service
  getIt.registerLazySingleton(
    () => AuthApiService(
      googleSignIn,
    ),
  );

  ///Provider

  getIt.registerLazySingleton<WalletProvider>(
    () => WalletProvider(coreWallet),
  );

  getIt.registerLazySingleton<SmartAccountProvider>(
    () => SmartAccountProvider(
      auraSmartAccount,
    ),
  );

  /// Local

  getIt.registerLazySingleton<AccountStorageService>(
    () => AccountStorageService(
      isar,
    ),
  );

  getIt.registerLazySingleton(
    () => const SecureStorageService(
      secureStorage,
    ),
  );

  ///Repository

  getIt.registerLazySingleton<AppSecureRepository>(
    () => AppSecureRepositoryImpl(
      getIt.get<SecureStorageService>(),
    ),
  );

  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(),
  );

  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      getIt.get<WalletProvider>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt.get<AuthApiService>(),
    ),
  );

  getIt.registerLazySingleton<SmartAccountRepository>(
    () => SmartAccountRepositoryImpl(
      getIt.get<SmartAccountProvider>(),
    ),
  );

  getIt.registerLazySingleton<ControllerKeyRepository>(
    () => ControllerKeyRepositoryImpl(
      getIt.get<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<AuraAccountRepository>(
    () => AuraAccountRepositoryImpl(
      getIt.get<AccountStorageService>(),
    ),
  );

  ///Use case
  getIt.registerLazySingleton<AppSecureUseCase>(
    () => AppSecureUseCase(
      getIt.get<AppSecureRepository>(),
    ),
  );

  getIt.registerLazySingleton<LocalizationUseCase>(
    () => LocalizationUseCase(
      getIt.get<LocalizationRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => WalletUseCase(
      getIt.get<WalletRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => AuthUseCase(
      getIt.get<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<SmartAccountUseCase>(
    () => SmartAccountUseCase(
      getIt.get<SmartAccountRepository>(),
    ),
  );

  getIt.registerLazySingleton<AuraAccountUseCase>(
    () => AuraAccountUseCase(
      getIt.get<AuraAccountRepository>(),
    ),
  );
  getIt.registerLazySingleton<ControllerKeyUseCase>(
    () => ControllerKeyUseCase(
      getIt.get<ControllerKeyRepository>(),
    ),
  );

  ///Bloc
  getIt.registerFactory<SplashScreenCubit>(
    () => SplashScreenCubit(
      getIt.get<AppSecureUseCase>(),
    ),
  );

  getIt.registerFactory<OnBoardingPickAccountBloc>(
    () => OnBoardingPickAccountBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
    ),
  );

  getIt.registerFactory<OnBoardingImportKeyBloc>(
    () => OnBoardingImportKeyBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      getIt.get<AuraAccountUseCase>(),
    ),
  );

  getIt.registerFactoryParam<OnBoardingScanFeeBloc, Map<String, String>,
      Map<String, Uint8List>>(
    (smartAccount, accountRaw) => OnBoardingScanFeeBloc(
      getIt.get<SmartAccountUseCase>(),
      getIt.get<AuraAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      smartAccountAddress: smartAccount['smartAccountAddress']!,
      accountName: smartAccount['accountName']!,
      privateKey: accountRaw['privateKey']!,
      salt: accountRaw['salt']!,
    ),
  );

  getIt.registerFactory<OnBoardingRecoverChoiceBloc>(
    () => OnBoardingRecoverChoiceBloc(
      getIt.get<AuthUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => HomeScreenBloc(
      getIt.get<AuraAccountUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => SignedInCreateNewSmAccountPickAccountBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
    ),
  );

  getIt.registerFactoryParam<SignedInCreateNewSmAccountScanFeeBloc,
      Map<String, String>, Map<String, Uint8List>>(
    (smartAccount, accountRaw) => SignedInCreateNewSmAccountScanFeeBloc(
      getIt.get<SmartAccountUseCase>(),
      smartAccountAddress: smartAccount['smartAccountAddress']!,
      accountName: smartAccount['accountName']!,
      privateKey: accountRaw['privateKey']!,
      salt: accountRaw['salt']!,
    ),
  );

  getIt.registerFactory(
    () => SignedInImportKeyBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
      getIt.get<AuraAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
    ),
  );

  getIt.registerFactory<OnBoardingSetupPasscodeBloc>(
    () => OnBoardingSetupPasscodeBloc(
      getIt.get<AppSecureUseCase>(),
    ),
  );
  getIt.registerFactory<OnBoardingReLoginBloc>(
    () => OnBoardingReLoginBloc(
      getIt.get<AppSecureUseCase>(),
      getIt.get<AuraAccountUseCase>(),
    ),
  );

  getIt.registerFactory<SendTransactionBloc>(
    () => SendTransactionBloc(
      getIt.get<AuraAccountUseCase>(),
      getIt.get<SmartAccountUseCase>(),
    ),
  );
}
