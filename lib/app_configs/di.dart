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


  ///Use case


  ///Bloc
  getIt.registerFactory<SplashScreenCubit>(
    () => SplashScreenCubit(),
  );
}
