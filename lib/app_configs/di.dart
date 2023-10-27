import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:aura_wallet_core/config_options/environment_options.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_import_key/on_boarding_import_key_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_pick_account/on_boarding_pick_account_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_choice/on_boarding_recover_choice_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_scan_fee/on_boarding_scan_fee_bloc.dart';

import 'pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initDependency(
  PyxisMobileConfig config,
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

  final GoogleSignIn googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    clientId:
        config.googleClientId,
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final AuraWalletCore coreWallet = AuraWalletCore.create(
    environment: AuraEnvironment.testNet,
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

  getIt.registerLazySingleton<WalletService>(
    () => WalletService(coreWallet),
  );

  ///Repository
  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(),
  );

  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      getIt.get<WalletService>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt.get<AuthApiService>(),
    ),
  );

  ///Use case
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

  ///Bloc
  getIt.registerFactory<SplashScreenCubit>(
    () => SplashScreenCubit(),
  );

  getIt.registerFactory<OnBoardingPickAccountBloc>(
    () => OnBoardingPickAccountBloc(
      getIt.get<WalletUseCase>(),
    ),
  );

  getIt.registerFactory<OnBoardingImportKeyBloc>(
    () => OnBoardingImportKeyBloc(
      getIt.get<WalletUseCase>(),
    ),
  );

  getIt.registerFactoryParam<OnBoardingScanFeeBloc, String, dynamic>(
    (smartAccountAddress, param2) => OnBoardingScanFeeBloc(
      smartAccountAddress: smartAccountAddress,
    ),
  );
  getIt.registerFactory<OnBoardingRecoverChoiceBloc>(
    () => OnBoardingRecoverChoiceBloc(
      getIt.get<AuthUseCase>(),
    ),
  );
}
