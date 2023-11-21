import 'dart:typed_data';

import 'package:data/src/data/resource/provider/provider.dart';
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
    required String fee,
    required int gasLimit,
  }) async {
    final response = await _provider.activeSmartAccount(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      fee: fee,
      gasLimit: gasLimit,
      salt: salt,
      memo: memo,
    );

    return response.address;
  }

  @override
  Future<String> generateAddress(
      {required Uint8List pubKey, Uint8List? salt}) async {
    final response = await _provider.generateSmartAccount(
      pubKey: pubKey,
      salt: salt,
    );

    return response.address;
  }
}
