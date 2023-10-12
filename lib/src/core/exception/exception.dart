import 'package:domain/domain.dart';

extension ExceptionMapper on AppError {
  PyxisException get toAuraWalletException => PyxisException(
        code: code,
        message: message ?? 'Unknown error',
      );
}

class PyxisException {
  final int code;
  final String message;

  const PyxisException({required this.code, required this.message});

  @override
  String toString() {
    return 'Pyxis exception : [$code] $message';
  }
}
