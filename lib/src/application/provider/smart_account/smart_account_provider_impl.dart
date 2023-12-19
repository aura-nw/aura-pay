import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

class SmartAccountProviderImpl implements SmartAccountProvider {
  final AuraSmartAccount _auraSmartAccount;

  const SmartAccountProviderImpl(
    this._auraSmartAccount,
  );

  @override
  Future<TransactionInformation> activeSmartAccount({
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

    return TransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
      status: response.code,
      rawLog: response.rawLog,
    ).toEntity;
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
  Future<TransactionInformationDto> sendToken({
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

    return TransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
      status: response.code,
      rawLog: response.rawLog,
    );
  }

  @override
  Future<int> simulateFee({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    dynamic msg
  }) {
    return _auraSmartAccount.simulateFee(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      msg: msg,
    );
  }

  @override
  Future<TransactionInformationDto> getTx({required String txHash}) async {
    final response = await _auraSmartAccount.getTx(
      txHash: txHash,
    );

    return TransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
      status: response.code,
      rawLog: response.rawLog,
    );
  }

  @override
  Future<TransactionInformationDto> setRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String recoverAddress,
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

    final response = await _auraSmartAccount.setRecoveryMethod(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      recoverAddress: recoverAddress,
      fee: smartAccountFee,
    );

    return TransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
      status: response.code,
      rawLog: response.rawLog,
    );
  }

  @override
  Future<TransactionInformationDto> unRegisterRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
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

    final response = await _auraSmartAccount.unRegisterRecoveryMethod(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      fee: smartAccountFee,
    );

    return TransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
      status: response.code,
      rawLog: response.rawLog,
    );
  }

  @override
  Future<TransactionInformationDto> recoverSmartAccount({
    required Uint8List privateKey,
    required String recoverAddress,
    required String smartAccountAddress,
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

    final response = await _auraSmartAccount.recoverSmartAccount(
      privateKey: privateKey,
      smartAccountAddress: smartAccountAddress,
      recoveryAddress: recoverAddress,
      fee: smartAccountFee,
    );

    return TransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
      status: response.code,
      rawLog: response.rawLog,
    );
  }
}
