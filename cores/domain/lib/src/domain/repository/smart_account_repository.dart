import 'dart:typed_data';

import 'package:domain/src/domain/entities/send_transaction_information.dart';

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
    String? fee,
    int? gasLimit,
  });

  Future<SendTransactionInformation> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
    String? fee,
    int? gasLimit,
  });

  Future<String> getToken({
    required String address,
  });

  Future<int> simulateFee({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
  });

  Future<SendTransactionInformation> getTx({
    required String txHash,
  });
}
