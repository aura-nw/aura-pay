final class SignInParameter {
  final String deviceId;
  final String data;
  final String signature;

  const SignInParameter({
    required this.deviceId,
    required this.data,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'data': data,
      'signature': signature,
    };
  }
}

