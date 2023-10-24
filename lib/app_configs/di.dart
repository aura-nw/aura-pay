import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      baseUrl: config.baseUrl + config.configs!.apiVersion,
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
    scopes: [
      'email',
    ],
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

  ///Repository
  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(),
  );

  ///Use case
  getIt.registerLazySingleton<LocalizationUseCase>(
    () => LocalizationUseCase(
      getIt.get<LocalizationRepository>(),
    ),
  );

  ///Bloc
  getIt.registerFactory<SplashScreenCubit>(
    () => SplashScreenCubit(),
  );
}
