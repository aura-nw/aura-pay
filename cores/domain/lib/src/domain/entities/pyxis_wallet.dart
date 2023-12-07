import 'package:flutter/services.dart';

abstract class PyxisWallet {
  final String bech32Address;
  final String? privateKey;
  final String? mnemonic;
  final Uint8List publicKey;

  const PyxisWallet({
    required this.bech32Address,
    required this.publicKey,
    this.privateKey,
    this.mnemonic,
  });

  Future<T> sendTransaction<T>({
    required String toAddress,
    required String amount,
    required String fee,
    required int gasLimit,
    String? memo,
  });

  Future<bool> submitTransaction<P>({
    required P signedTransaction,
  });

  Future<String> checkWalletBalance();
}
