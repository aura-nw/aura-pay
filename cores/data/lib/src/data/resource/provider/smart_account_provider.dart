import 'dart:typed_data';

abstract interface class SmartAccountProvider{
  Future<String> generateSmartAccount({
    required Uint8List pubKey,
    Uint8List? salt,
  });

  Future<String> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    String? fee,
    int? gasLimit,
  });

  Future<int> simulateFee({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
  });

  Future<String> getToken({
    required String address,
  });

  Future<String> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? fee,
    int? gasLimit,
    String? memo,
  });
}