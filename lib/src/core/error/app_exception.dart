/// Custom application exceptions
/// Định nghĩa các loại exceptions riêng cho app

/// Base exception class cho tất cả app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noConnection() {
    return const NetworkException(
      message: 'No internet connection. Please check your network settings.',
      code: 'NETWORK_NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Request timeout. Please try again.',
      code: 'NETWORK_TIMEOUT',
    );
  }

  factory NetworkException.serverError([int? statusCode]) {
    return NetworkException(
      message: 'Server error occurred. Please try again later.',
      code: 'NETWORK_SERVER_ERROR_${statusCode ?? 500}',
    );
  }

  @override
  String toString() => 'NetworkException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Authentication-related exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthenticationException.unauthorized() {
    return const AuthenticationException(
      message: 'Authentication failed. Please login again.',
      code: 'AUTH_UNAUTHORIZED',
    );
  }

  factory AuthenticationException.sessionExpired() {
    return const AuthenticationException(
      message: 'Your session has expired. Please login again.',
      code: 'AUTH_SESSION_EXPIRED',
    );
  }

  factory AuthenticationException.invalidCredentials() {
    return const AuthenticationException(
      message: 'Invalid credentials. Please check and try again.',
      code: 'AUTH_INVALID_CREDENTIALS',
    );
  }

  @override
  String toString() => 'AuthenticationException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Wallet-related exceptions
class WalletException extends AppException {
  const WalletException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory WalletException.insufficientBalance() {
    return const WalletException(
      message: 'Insufficient balance for this transaction.',
      code: 'WALLET_INSUFFICIENT_BALANCE',
    );
  }

  factory WalletException.invalidAddress() {
    return const WalletException(
      message: 'Invalid wallet address. Please check and try again.',
      code: 'WALLET_INVALID_ADDRESS',
    );
  }

  factory WalletException.transactionFailed(String? reason) {
    return WalletException(
      message: reason ?? 'Transaction failed. Please try again.',
      code: 'WALLET_TRANSACTION_FAILED',
    );
  }

  factory WalletException.invalidMnemonic() {
    return const WalletException(
      message: 'Invalid mnemonic phrase. Please check and try again.',
      code: 'WALLET_INVALID_MNEMONIC',
    );
  }

  factory WalletException.invalidPrivateKey() {
    return const WalletException(
      message: 'Invalid private key. Please check and try again.',
      code: 'WALLET_INVALID_PRIVATE_KEY',
    );
  }

  factory WalletException.walletGenerationFailed([String? reason]) {
    return WalletException(
      message: reason ?? 'Failed to generate wallet. Please try again.',
      code: 'WALLET_GENERATION_FAILED',
    );
  }

  @override
  String toString() => 'WalletException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Database-related exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory DatabaseException.notFound(String entity) {
    return DatabaseException(
      message: '$entity not found.',
      code: 'DB_NOT_FOUND',
    );
  }

  factory DatabaseException.saveFailed(String entity) {
    return DatabaseException(
      message: 'Failed to save $entity.',
      code: 'DB_SAVE_FAILED',
    );
  }

  factory DatabaseException.deleteFailed(String entity) {
    return DatabaseException(
      message: 'Failed to delete $entity.',
      code: 'DB_DELETE_FAILED',
    );
  }

  @override
  String toString() => 'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.invalidInput(String field, [String? reason]) {
    return ValidationException(
      message: reason ?? 'Invalid $field.',
      code: 'VALIDATION_INVALID_INPUT',
      fieldErrors: {field: reason ?? 'Invalid input'},
    );
  }

  factory ValidationException.requiredField(String field) {
    return ValidationException(
      message: '$field is required.',
      code: 'VALIDATION_REQUIRED_FIELD',
      fieldErrors: {field: 'This field is required'},
    );
  }

  @override
  String toString() => 'ValidationException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Biometric authentication exceptions
class BiometricException extends AppException {
  const BiometricException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory BiometricException.notAvailable() {
    return const BiometricException(
      message: 'Biometric authentication is not available on this device.',
      code: 'BIOMETRIC_NOT_AVAILABLE',
    );
  }

  factory BiometricException.notEnrolled() {
    return const BiometricException(
      message: 'No biometrics enrolled. Please set up biometric authentication in your device settings.',
      code: 'BIOMETRIC_NOT_ENROLLED',
    );
  }

  factory BiometricException.failed() {
    return const BiometricException(
      message: 'Biometric authentication failed. Please try again.',
      code: 'BIOMETRIC_FAILED',
    );
  }

  factory BiometricException.cancelled() {
    return const BiometricException(
      message: 'Biometric authentication was cancelled.',
      code: 'BIOMETRIC_CANCELLED',
    );
  }

  @override
  String toString() => 'BiometricException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Storage exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory StorageException.readFailed(String key) {
    return StorageException(
      message: 'Failed to read from storage: $key',
      code: 'STORAGE_READ_FAILED',
    );
  }

  factory StorageException.writeFailed(String key) {
    return StorageException(
      message: 'Failed to write to storage: $key',
      code: 'STORAGE_WRITE_FAILED',
    );
  }

  factory StorageException.deleteFailed(String key) {
    return StorageException(
      message: 'Failed to delete from storage: $key',
      code: 'STORAGE_DELETE_FAILED',
    );
  }

  @override
  String toString() => 'StorageException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Unknown/Unexpected exceptions
class UnknownException extends AppException {
  const UnknownException({
    String message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message);

  @override
  String toString() => 'UnknownException: $message${code != null ? ' (Code: $code)' : ''}';
}

