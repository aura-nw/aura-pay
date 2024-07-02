class AuraWallet {
  final String address;
  final String publicKey;
  final String privateKey;
  final String? mnemonic;

  AuraWallet({
    required this.address,
    required this.publicKey,
    required this.privateKey,
    this.mnemonic,
  });

  factory AuraWallet.fromJson(Map<String, dynamic> json) {
    return AuraWallet(
      address: json['address'],
      publicKey: json['publicKey'],
      privateKey: json['privateKey'],
      mnemonic: json['mnemonic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'publicKey': publicKey,
      'privateKey': privateKey,
      'mnemonic': mnemonic,
    };
  }
}
