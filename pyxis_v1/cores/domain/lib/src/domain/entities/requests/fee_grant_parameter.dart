final class FeeGrantParameter {
  final String pubKey;
  final String deviceId;
  final String granteeWallet;

  const FeeGrantParameter({
    required this.pubKey,
    required this.deviceId,
    required this.granteeWallet,
  });

  Map<String, dynamic> toJson() {
    return {
      'pubkey' : pubKey,
      'deviceId' : deviceId,
      'granteeWallet' : granteeWallet,
    };
  }
}
