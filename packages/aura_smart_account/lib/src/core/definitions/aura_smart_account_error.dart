import 'package:aura_smart_account/src/core/constants/smart_account_error_code.dart';

class AuraSmartAccountError extends Error {
  final int code;
  final String errorMsg;

  AuraSmartAccountError({
    required this.code,
    required this.errorMsg,
  });

  @override
  String toString() {
    return '[$code] $errorMsg';
  }

  bool get isUnknownError => code == SmartAccountErrorCode.errorCodeDefault;

  bool get isErrorBroadcast => code == SmartAccountErrorCode.errorBroadcast;

  bool get isGrpcError =>
      code != SmartAccountErrorCode.errorCodeDefault &&
      code != SmartAccountErrorCode.errorBroadcast;
}
