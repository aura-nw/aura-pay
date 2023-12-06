import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';

class SmartAccountProvider {
  final AuraSmartAccount _provider;

  const SmartAccountProvider(this._provider);

  Future<QueryGenerateAccountResponse> generateSmartAccount({
    required Uint8List pubKey,
    Uint8List? salt,
  }) async {
    return _provider.generateSmartAccount(
      pubKey: pubKey,
      salt: salt,
    );
  }

  Future<MsgActivateAccountResponse> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    required String fee,
    required int gasLimit,
  }) async {
    return _provider.activeSmartAccount(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      fee: fee,
      gasLimit: gasLimit,
      salt: salt,
      memo: memo,
    );
  }

  Future<TxResponse> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
    required String fee,
    required int gasLimit,
  }) async {
    return _provider.sendToken(
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
    return _provider.getToken(
      address: address,
    );
  }

  Future<int> simulateFee(
      {required Uint8List userPrivateKey,
      required String smartAccountAddress,
      required String receiverAddress,
      required String amount,
      String? memo}) {
    return _provider.simulateFee(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      memo: memo,
    );
  }
}
