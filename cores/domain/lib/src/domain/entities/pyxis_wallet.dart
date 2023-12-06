import 'package:flutter/services.dart';

abstract class PyxisWallet<T> {
  String get bech32Address;
  String? get privateKey;
  String? get mnemonic;
  Uint8List get publicKey;
}
