import 'dart:typed_data';
import 'package:domain/domain.dart';

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
    String ?granter,
  }) async {
    return _repository.activeSmartAccount(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      fee: fee,
      gasLimit: gasLimit,
      salt: salt,
      memo: memo,
      granter: granter,
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

  Future<int> simulateFee(
      {required Uint8List userPrivateKey,
      required String smartAccountAddress,
      dynamic msg}) {
    return _repository.simulateFee(
        userPrivateKey: userPrivateKey,
        smartAccountAddress: smartAccountAddress,
        msg: msg);
  }

  Future<TransactionInformation> getTx({
    required String txHash,
  }) async {
    return _repository.getTx(
      txHash: txHash,
    );
  }

  Future<TransactionInformation> setRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String recoverAddress,
    String? fee,
    int? gasLimit,
    bool isReadyRegister = false,
    String? revokePreAddress,
  }) async {
    return _repository.setRecoveryMethod(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      recoverAddress: recoverAddress,
      gasLimit: gasLimit,
      fee: fee,
      isReadyRegister: isReadyRegister,
      revokePreAddress: revokePreAddress,
    );
  }

  Future<TransactionInformation> recoverSmartAccount({
    required Uint8List privateKey,
    required String recoverAddress,
    required String smartAccountAddress,
    String? fee,
    int? gasLimit,
  }) async {
    return _repository.recoverSmartAccount(
      privateKey: privateKey,
      recoverAddress: recoverAddress,
      smartAccountAddress: smartAccountAddress,
      fee: fee,
      gasLimit: gasLimit,
    );
  }
}
