import 'dart:typed_data';

import 'package:data/src/data/dto/dto.dart';
import 'package:domain/domain.dart';

abstract interface class SmartAccountProvider {
  Future<String> generateSmartAccount({
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

  Future<int> simulateFee(
      {required Uint8List userPrivateKey,
      required String smartAccountAddress,
      dynamic msg});

  Future<String> getToken({
    required String address,
  });

  Future<TransactionInformationDto> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? fee,
    int? gasLimit,
    String? memo,
  });

  Future<TransactionInformationDto> getTx({
    required String txHash,
  });

  Future<TransactionInformationDto> setRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String recoverAddress,
    String? fee,
    int? gasLimit,
  });

  Future<TransactionInformationDto> unRegisterRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    String? fee,
    int? gasLimit,
  });

  Future<TransactionInformationDto> recoverSmartAccount({
    required Uint8List privateKey,
    required String recoverAddress,
    required String smartAccountAddress,
    String? fee,
    int? gasLimit,
  });
}
