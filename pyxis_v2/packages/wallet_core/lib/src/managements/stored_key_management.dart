import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:wallet_core/src/constants/constants.dart';
import 'package:wallet_core/src/objects/wallet_exception.dart';

class StoredManagement {
  /// Stores a private key.
  ///
  /// [name] is the name of the stored key.
  /// [password] is the password for the stored key.
  /// [privateKey] is the private key in hex format.
  /// [coinType] specifies the type of the coin.
  /// Returns the JSON representation of the stored key.
  String? storePrivateKey(String name, String password, String privateKeyHex,
      {int coinType = Constants.defaultCoinType}) {
    try {
      final privateKeyBytes = Uint8List.fromList(hex.decode(privateKeyHex));
      final storedKey =
          StoredKey.importPrivateKey(privateKeyBytes, name, password, coinType);
      String? json = storedKey?.exportJson();
      if (json == null) {
        throw WalletException('Failed to store private key');
      }
      return json;
    } catch (e) {
      throw WalletException('Failed to store private key: $e');
    }
  }

  /// Loads a stored key from a file.
  ///
  /// [path] is the file path of the stored key.
  /// Returns the loaded StoredKey.
  StoredKey? loadStoredKey(String path) {
    return StoredKey.load(path);
  }

  /// Imports a stored key from JSON.
  ///
  /// [json] is the JSON representation of the stored key.
  /// Returns the imported StoredKey.
  StoredKey? fromJson(String json) {
    return StoredKey.importJson(json);
  }
}
