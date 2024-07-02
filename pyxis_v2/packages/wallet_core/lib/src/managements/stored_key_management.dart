import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:wallet_core/src/constants/constants.dart';
import 'package:wallet_core/src/objects/wallet_exception.dart';
import 'package:wallet_core/wallet_core.dart';

class StoredManagement {
  String? saveWallet(String name, String password, AWallet aWallet,
      {int coinType = Constants.defaultCoinType}) {
    try {
      StoredKey? storedKey;
      if (aWallet.wallet != null) {
        storedKey = StoredKey.importHDWallet(
            aWallet.wallet!.mnemonic(), name, password, coinType);
      } else {
        storedKey = StoredKey.importPrivateKey(
            Uint8List.fromList(hex.decode(aWallet.privateKey)),
            name,
            password,
            coinType);
      }

      String? storedKeyOutput = storedKey?.exportJson();
      if (storedKey == null) {
        throw WalletException('Failed to save wallet');
      }
      return storedKeyOutput;
    } catch (e) {
      throw WalletException('Failed to save wallet: $e');
    }
  }

  /// Imports a stored key from JSON.
  ///
  /// [json] is the JSON representation of the stored key.
  /// Returns the imported StoredKey.
  AWallet? fromSavedJson(String storedKey, String password) {
    StoredKey? storedWallet = StoredKey.importJson(storedKey);

    if (storedWallet == null) {
      return null;
    }

    if (storedWallet.isMnemonic()) {
      HDWallet? hdWallet = storedWallet.wallet(password);
      if (hdWallet == null) {
        return null;
      }
      return WalletCore.walletManagement.importWallet(hdWallet.mnemonic());
    }

    PrivateKey? privateKey = storedWallet.privateKey(
        Constants.defaultCoinType, Uint8List.fromList(password.codeUnits));
    if (privateKey == null) {
      return null;
    }
    String privateKeyHex = hex.encode(privateKey.data());
    return WalletCore.walletManagement
        .importWalletWithPrivateKey(privateKeyHex);
  }
}
