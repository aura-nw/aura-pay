import 'dart:typed_data';

import 'package:data/src/data/dto/dto.dart';

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

  Future<SendTransactionInformationDto> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? fee,
    int? gasLimit,
    String? memo,
  });
}