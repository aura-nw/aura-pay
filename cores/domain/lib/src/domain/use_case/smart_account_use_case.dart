import 'dart:typed_data';

import 'package:domain/src/domain/repository/repository.dart';

class SmartAccountUseCase {
  final SmartAccountRepository _repository;

  const SmartAccountUseCase(this._repository);

  Future<String> generateSmartAccount({
    required Uint8List pubKey,
    Uint8List? salt,
  }) async {
    return _repository.generateAddress(
      pubKey: pubKey,
      salt: salt,
    );
  }

  Future<String> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    required String fee,
    required int gasLimit,
  }) async {
    return _repository.activeSmartAccount(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      fee: fee,
      gasLimit: gasLimit,
      salt: salt,
      memo: memo,
    );
  }

  Future<String> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
    required String fee,
    required int gasLimit,
  }) async {
    return _repository.sendToken(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      fee: fee,
      gasLimit: gasLimit,
      memo: memo,
    );
  }

  Future<String> getToken({
    required String address,
  }) async {
    return _repository.getToken(
      address: address,
    );
  }

  Future<int> simulateFee({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
  }) {
    return _repository.simulateFee(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      memo: memo,
    );
  }
}
