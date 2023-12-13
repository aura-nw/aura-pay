import 'dart:typed_data';

import 'package:domain/src/domain/entities/entities.dart';

abstract interface class SmartAccountRepository {
  Future<String> generateAddress({
    required Uint8List pubKey,
    Uint8List? salt,
  });

  Future<TransactionInformation> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    String? fee,
    int? gasLimit,
  });

  Future<TransactionInformation> sendToken({
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

  Future<TransactionInformation> getTx({
    required String txHash,
  });

  Future<List<PyxisTransaction>> getTransactionHistories({
    required List<String> events,
    required int limit,
    required int offset,
    required String orderBy,
  });

  Future<TransactionInformation> setRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String recoverAddress,
    String? fee,
    int? gasLimit,
  });
}
