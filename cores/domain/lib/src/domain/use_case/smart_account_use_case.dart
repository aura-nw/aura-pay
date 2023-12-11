import 'dart:typed_data';
import 'package:domain/src/domain/entities/entities.dart';
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

  Future<TransactionInformation> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    String? fee,
    int? gasLimit,
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

  Future<TransactionInformation> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
    String? fee,
    int? gasLimit,
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

  Future<TransactionInformation> getTx({
    required String txHash,
  }) async {
    return _repository.getTx(
      txHash: txHash,
    );
  }

  Future<List<PyxisTransaction>> getTransactionHistories({
    required int limit,
    required int offset,
    required List<String> events,
    required String orderBy,
  }) {
    return _repository.getTransactionHistories(
      events: events,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );
  }
}
