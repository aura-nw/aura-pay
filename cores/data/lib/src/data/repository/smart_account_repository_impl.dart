import 'dart:typed_data';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

class SmartAccountRepositoryImpl implements SmartAccountRepository {
  final SmartAccountProvider _provider;

  const SmartAccountRepositoryImpl(this._provider);

  @override
  Future<String> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    String? fee,
    int? gasLimit,
  }) async {
    return await _provider.activeSmartAccount(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      fee: fee,
      gasLimit: gasLimit,
      salt: salt,
      memo: memo,
    );
  }

  @override
  Future<String> generateAddress({
    required Uint8List pubKey,
    Uint8List? salt,
  }) async {
    return await _provider.generateSmartAccount(
      pubKey: pubKey,
      salt: salt,
    );
  }

  @override
  Future<SendTransactionInformation> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
    String? fee,
    int? gasLimit,
  }) async {
    final transactionResponse = await _provider.sendToken(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      fee: fee,
      gasLimit: gasLimit,
      memo: memo,
    );
    return transactionResponse.toEntity;
  }

  @override
  Future<String> getToken({
    required String address,
  }) async {
    return _provider.getToken(
      address: address,
    );
  }

  @override
  Future<int> simulateFee({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
  }) {
    return _provider.simulateFee(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      memo: memo,
    );
  }

  @override
  Future<SendTransactionInformation> getTx({required String txHash}) async {
    final response = await _provider.getTx(
      txHash: txHash,
    );
    return response.toEntity;
  }
}
