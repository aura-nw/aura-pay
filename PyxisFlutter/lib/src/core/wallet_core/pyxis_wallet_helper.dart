import 'package:aura_wallet_core/aura_wallet_core.dart';

class PyxisWalletHelper {
  static String getPrivateKeyFromBytes(privateKeyFromString) {
    return AuraWalletHelper.getPrivateKeyFromBytes(privateKeyFromString);
  }

  static getPrivateKeyFromString(String s) {
    return AuraWalletHelper.getPrivateKeyFromString(s);
  }

  static bool checkPrivateKey(String value) {
    return AuraWalletHelper.checkPrivateKey(value.trim());
  }

  static bool checkMnemonic({required String mnemonic}) {
    return AuraWalletHelper.checkMnemonic(mnemonic: mnemonic);
  }

  static Map<String, dynamic> signAmino(
      {required signDoc,
      required String privateKeyHex,
      required String pubKeyHex}) {
    return AuraCoreHelper.signAmino(
        signDoc: signDoc, privateKeyHex: privateKeyHex, pubKeyHex: pubKeyHex);
  }
}
