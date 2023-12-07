import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:data/data.dart';

class SmartAccountProviderImpl implements SmartAccountProvider {
  final AuraSmartAccount _auraSmartAccount;

  const SmartAccountProviderImpl(
    this._auraSmartAccount,
  );

  @override
  Future<String> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    String? fee,
    int? gasLimit,
  }) async {
    AuraSmartAccountFee? smartAccountFee;

    if (fee != null && gasLimit != null) {
      smartAccountFee = AuraSmartAccountFee(
        fee: fee,
        gasLimit: gasLimit,
      );
    }

    final response = await _auraSmartAccount.activeSmartAccount(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      memo: memo,
      salt: salt,
      fee: smartAccountFee,
    );

    return response.address;
  }

  @override
  Future<String> generateSmartAccount({
    required Uint8List pubKey,
    Uint8List? salt,
  }) async {
    final response = await _auraSmartAccount.generateSmartAccount(
      pubKey: pubKey,
      salt: salt,
    );

    return response.address;
  }

  @override
  Future<String> getToken({required String address}) {
    return _auraSmartAccount.getToken(
      address: address,
    );
  }

  @override
  Future<SendTransactionInformationDto> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? fee,
    int? gasLimit,
    String? memo,
  }) async {
    AuraSmartAccountFee? smartAccountFee;

    if (fee != null && gasLimit != null) {
      smartAccountFee = AuraSmartAccountFee(
        fee: fee,
        gasLimit: gasLimit,
      );
    }

    final response = await _auraSmartAccount.sendToken(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      fee: smartAccountFee,
    );

    return SendTransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
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
    return _auraSmartAccount.simulateFee(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      memo: memo,
    );
  }
}
