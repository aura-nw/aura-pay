import 'package:aura_wallet_core/aura_wallet_core.dart';

class PyxisWalletHelper {
  static String getPrivateKeyFromBytes(privateKeyFromString) {
    // throw UnimplementedError();
    return AuraWalletHelper.getPrivateKeyFromBytes(privateKeyFromString);
  }

  static getPrivateKeyFromString(String s) {
    // throw UnimplementedError();
    return AuraWalletHelper.getPrivateKeyFromString(s);
  }

  static bool checkPrivateKey(String value) {
    print('#Pyxis#1 checkPrivateKey: $value');
    // throw UnimplementedError();
    return AuraWalletHelper.checkPrivateKey(value.trim());
  }

  static bool checkMnemonic({required String mnemonic}) {
    // throw UnimplementedError();
    return AuraWalletHelper.checkMnemonic(mnemonic: mnemonic);
  }

  static Map<String, dynamic> signAmino(
      {required signDoc,
      required String privateKeyHex,
      required String pubKeyHex}) {
    // throw UnimplementedError();
    return AuraCoreHelper.signAmino(
        signDoc: signDoc, privateKeyHex: privateKeyHex, pubKeyHex: pubKeyHex);
  }
}
