import 'dart:typed_data';

abstract interface class SmartAccountRepository {
  Future<String> generateAddress({
    required Uint8List pubKey,
    Uint8List? salt,
  });

  Future<String> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    required String fee,
    required int gasLimit,
  });

  Future<String> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
    required String fee,
    required int gasLimit,
  });

  Future<String> getToken({
    required String address,
  });
}
