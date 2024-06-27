import 'dart:io';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_error_code.dart';
import 'package:pyxis_mobile/src/core/exception/core/base_exeption_wrapper_helper.dart';

final class PyxisExceptionWrapper extends BaseExceptionWrapperHelper {
  static BaseExceptionWrapperHelper _getInstance() => PyxisExceptionWrapper._instance();

  static BaseExceptionWrapperHelper get instance => _getInstance();

  PyxisExceptionWrapper._instance();

  @override
  Object? errorMapperHandler(AppError error) {
    return null;
  }

  @override
  AppError handleError(Object e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.sendTimeout:
          return AppError(
            code: PyxisErrorCode.sendTimeOut,
            message: e.message,
          );
        case DioExceptionType.badCertificate:
          return AppError(
            code: PyxisErrorCode.badCertificate,
            message: e.message,
          );
        case DioExceptionType.badResponse:
          final response = e.response;
          return AppError(
            code: response?.statusCode.toString() ?? PyxisErrorCode.badResponse,
            message: e.message,
          );
        case DioExceptionType.cancel:
          return AppError(
            code: PyxisErrorCode.cancel,
            message: e.message,
          );
        case DioExceptionType.connectionError:
          return AppError(
            code: PyxisErrorCode.connectionError,
            message: e.message,
          );
        case DioExceptionType.connectionTimeout:
          return AppError(
            code: PyxisErrorCode.connectionTimeout,
            message: e.message,
          );
        case DioExceptionType.receiveTimeout:
          return AppError(
            code: PyxisErrorCode.receiveTimeout,
            message: e.message,
          );
        case DioExceptionType.unknown:
          return _convertOtherExceptionOrElse(e);
      }
    }
    return const AppError(
      code: PyxisErrorCode.unknownError,
    );
  }

  AppError _convertOtherExceptionOrElse(Object ex) {
    if (ex is DioException && ex.error is FormatException) {
      return AppError(
          code: PyxisErrorCode.formatException, message: ex.message);
    }
    if (ex is FormatException) {
      return AppError(
        code: PyxisErrorCode.formatException,
        message: ex.message,
      );
    }
    if (ex is DioException && ex.error is SocketException) {
      return AppError(
        code: PyxisErrorCode.networkException,
        message: (ex.error as SocketException).message,
      );
    }

    if (ex is SocketException) {
      return AppError(
        code: PyxisErrorCode.networkException,
        message: ex.message,
      );
    }

    if (ex is DioException &&
        ex.error
            .toString()
            .toLowerCase()
            .contains('is not a subtype of'.toLowerCase())) {
      return AppError(
        code: PyxisErrorCode.unMatchType,
        message: ex.message,
      );
    }

    if (ex
        .toString()
        .toLowerCase()
        .contains('is not a subtype of'.toLowerCase())) {
      return AppError(
        code: PyxisErrorCode.unMatchType,
        message: ex.toString(),
      );
    }
    return const AppError(
      code: PyxisErrorCode.unknownError,
    );
  }
}
