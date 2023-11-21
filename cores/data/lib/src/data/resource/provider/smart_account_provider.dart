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
}
