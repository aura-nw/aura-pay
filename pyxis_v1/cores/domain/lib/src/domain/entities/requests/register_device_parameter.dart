final class RegisterDeviceParameter {
  final String pubKey;
  final String deviceId;
  final String data;
  final String signature;

  const RegisterDeviceParameter({
    required this.pubKey,
    required this.deviceId,
    required this.data,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    return {
      'pubkey': pubKey,
      'deviceId': deviceId,
      'data': data,
      'signature': signature,
    };
  }
}