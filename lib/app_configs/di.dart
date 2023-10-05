import 'package:pyxis_mobile/src/data/repository/localization_repository_impl.dart';
import 'package:pyxis_mobile/src/domain/repository/localization_repository.dart';
import 'package:pyxis_mobile/src/domain/use_case/localization_use_case.dart';

import 'pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initDependency(
  PyxisMobileConfig config,
) async {
  Dio dio = Dio(
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

  getIt.registerFactory<Dio>(
    () => dio,
  );

  getIt.registerLazySingleton<PyxisMobileConfig>(
    () => config,
  );

  ///Api service

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
