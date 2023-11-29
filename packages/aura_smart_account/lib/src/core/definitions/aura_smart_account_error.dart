import 'package:aura_smart_account/src/core/constants/smart_account_constant.dart';

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

  bool get isUnknownError => code == AuraSmartAccountConstant.errorCodeDefault;

  bool get isErrorBroadcast => code == AuraSmartAccountConstant.errorBroadcast;

  bool get isGrpcError =>
      code != AuraSmartAccountConstant.errorCodeDefault &&
      code != AuraSmartAccountConstant.errorBroadcast;
}
