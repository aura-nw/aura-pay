import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/exception/core/base_exeption_wrapper_helper.dart';

final class PyxisExceptionWrapper extends BaseExceptionWrapperHelper {
  @override
  Object? errorMapperHandler(AppError error) {
    // TODO: implement errorMapperHandler
    throw UnimplementedError();
  }

  @override
  AppError handleError(Object e) {
    if (e is DioException) {
      return AppError(
        code: e.toString(),
      );
    }
    return const AppError(
      code: '0',
    );
  }
}
