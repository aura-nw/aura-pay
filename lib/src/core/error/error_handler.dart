import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:aurapay/src/core/error/app_exception.dart';
import 'package:aurapay/src/core/utils/toast_helper.dart';

/// Centralized error handler cho toàn bộ app
/// 
/// Handles errors từ different sources và convert thành user-friendly messages
/// 
/// Usage:
/// ```dart
/// try {
///   // Some operation
/// } catch (e, stackTrace) {
///   AppErrorHandler.handle(e, stackTrace: stackTrace);
///   // hoặc với custom message
///   AppErrorHandler.handle(e, customMessage: 'Failed to load data');
/// }
/// ```
class AppErrorHandler {
  AppErrorHandler._();

  /// Handle error và show appropriate message to user
  /// 
  /// Parameters:
  /// - [error]: The error object
  /// - [stackTrace]: Optional stack trace for logging
  /// - [showToUser]: Whether to show toast message to user (default: true)
  /// - [customMessage]: Optional custom message thay vì auto-generated message
  /// - [logError]: Whether to log error (default: true)
  static void handle(
    dynamic error, {
    StackTrace? stackTrace,
    bool showToUser = true,
    String? customMessage,
    bool logError = true,
  }) {
    // Log error
    if (logError) {
      _logError(error, stackTrace);
    }

    // Get user-friendly message
    final message = customMessage ?? _mapErrorToMessage(error);

    // Show to user
    if (showToUser && message.isNotEmpty) {
      ToastHelper.showError(message);
    }
  }

  /// Handle error và return AppException
  /// Useful khi muốn re-throw hoặc pass exception lên
  static AppException toAppException(dynamic error, {StackTrace? stackTrace}) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _mapDioException(error);
    }

    if (error is SocketException) {
      return NetworkException.noConnection();
    } else if (error is TimeoutException) {
      return NetworkException.timeout();
    } else if (error is FormatException) {
      return ValidationException(
        message: 'Invalid data format: ${error.message}',
        code: 'VALIDATION_FORMAT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Unknown error
    return UnknownException(
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Map error to user-friendly message
  static String _mapErrorToMessage(dynamic error) {
    // Already an AppException
    if (error is AppException) {
      return error.message;
    }

    // DioException (Network errors)
    if (error is DioException) {
      return _mapDioExceptionToMessage(error);
    }

    // Socket/Network errors
    if (error is SocketException) {
      return 'No internet connection. Please check your network settings.';
    } else if (error is TimeoutException) {
      return 'Request timeout. Please try again.';
    } else if (error is FormatException) {
      return 'Invalid data format. Please try again.';
    }

    // State errors
    if (error is StateError) {
      return 'Invalid state. Please restart the app.';
    }

    // Argument errors
    if (error is ArgumentError) {
      return 'Invalid input. Please check and try again.';
    }

    // Type errors
    if (error is TypeError) {
      return 'An unexpected error occurred. Please try again.';
    }

    // String errors
    if (error is String) {
      return error;
    }

    // Exception with message property
    if (error is Exception) {
      final errorString = error.toString();
      // Remove "Exception: " prefix if exists
      if (errorString.startsWith('Exception: ')) {
        return errorString.substring('Exception: '.length);
      }
      return errorString;
    }

    // Default fallback
    return 'An unexpected error occurred. Please try again.';
  }

  /// Map DioException to AppException
  static AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return AuthenticationException.unauthorized();
        }
        return NetworkException.serverError(statusCode);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled.',
          code: 'NETWORK_CANCELLED',
        );

      case DioExceptionType.connectionError:
        return NetworkException.noConnection();

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Security certificate error. Please check your connection.',
          code: 'NETWORK_BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException.noConnection();
        }
        return NetworkException(
          message: error.message ?? 'Network error occurred.',
          code: 'NETWORK_UNKNOWN',
          originalError: error,
        );
    }
  }

  /// Map DioException to user message
  static String _mapDioExceptionToMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timeout. Please try again.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'Invalid request. Please check your input.';
          case 401:
          case 403:
            return 'Authentication failed. Please login again.';
          case 404:
            return 'Resource not found.';
          case 500:
          case 502:
          case 503:
            return 'Server error. Please try again later.';
          default:
            return 'Server error occurred (Code: $statusCode).';
        }

      case DioExceptionType.cancel:
        return ''; // Don't show message for cancelled requests

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';

      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please check your connection.';

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return 'No internet connection. Please check your network settings.';
        }
        return 'Network error occurred. Please try again.';
    }
  }

  /// Log error cho debugging
  static void _logError(dynamic error, StackTrace? stackTrace) {
    final errorMessage = _buildErrorLog(error, stackTrace);
    LogProvider.log(errorMessage);

    // TODO: Send to crash analytics (Firebase Crashlytics, Sentry, etc.)
    // if (!kDebugMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // }
  }

  /// Build error log message
  static String _buildErrorLog(dynamic error, StackTrace? stackTrace) {
    final buffer = StringBuffer();
    buffer.writeln('❌ ERROR OCCURRED ❌');
    buffer.writeln('Time: ${DateTime.now()}');
    buffer.writeln('Error Type: ${error.runtimeType}');
    buffer.writeln('Error: $error');

    if (error is AppException) {
      if (error.code != null) {
        buffer.writeln('Error Code: ${error.code}');
      }
      if (error.originalError != null) {
        buffer.writeln('Original Error: ${error.originalError}');
      }
    }

    if (stackTrace != null) {
      buffer.writeln('Stack Trace:');
      buffer.writeln(stackTrace.toString());
    }

    buffer.writeln('═' * 80);
    return buffer.toString();
  }

  /// Check if error is critical (cần user action hoặc app restart)
  static bool isCriticalError(dynamic error) {
    if (error is AuthenticationException) {
      return true;
    }
    if (error is DioException && error.response?.statusCode == 401) {
      return true;
    }
    return false;
  }

  /// Get error code from any error
  static String? getErrorCode(dynamic error) {
    if (error is AppException) {
      return error.code;
    }
    if (error is DioException) {
      return 'NETWORK_${error.response?.statusCode ?? 'UNKNOWN'}';
    }
    return null;
  }
}

