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

  Future<int> simulateFee(
      {required Uint8List userPrivateKey,
      required String smartAccountAddress,
      dynamic msg});

  Future<TransactionInformation> getTx({
    required String txHash,
  });

  Future<TransactionInformation> setRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String recoverAddress,
    String? fee,
    int? gasLimit,
  });

  Future<TransactionInformation> unRegisterRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    String? fee,
    int? gasLimit,
  });

  Future<TransactionInformation> recoverSmartAccount({
    required Uint8List privateKey,
    required String recoverAddress,
    required String smartAccountAddress,
    String? fee,
    int? gasLimit,
  });
}
