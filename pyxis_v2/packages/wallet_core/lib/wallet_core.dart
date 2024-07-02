library wallet_core;

import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:wallet_core/src/constants/constants.dart';

// Exporting necessary packages for external usage
export 'package:trust_wallet_core/trust_wallet_core_ffi.dart';
export 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
export 'package:trust_wallet_core/trust_wallet_core.dart';

/// WalletCore class provides various functionalities to manage wallets.
class WalletCore {
  /// Initializes the FlutterTrustWalletCore library.
  static void init() {
    FlutterTrustWalletCore.init();
  }

  /// Generates a random mnemonic phrase.
  ///
  /// [strength] determines the strength of the mnemonic phrase.
  /// [passphrase] is an optional passphrase to use with the mnemonic.
  /// Returns the generated mnemonic phrase.
  static String randomMnemonic({int strength = 128, String passphrase = ''}) {
    return HDWallet(strength: strength, passphrase: passphrase).mnemonic();
  }

  /// Generates a random HDWallet.
  ///
  /// [strength] determines the strength of the mnemonic phrase.
  /// [passphrase] is an optional passphrase to use with the mnemonic.
  /// Returns the generated HDWallet.
  static HDWallet randomWallet({int strength = 128, String passphrase = ''}) {
    return HDWallet(strength: strength, passphrase: passphrase);
  }

  /// Imports a wallet using a mnemonic phrase.
  ///
  /// [mnemonic] is the mnemonic phrase of the wallet.
  /// Returns the imported HDWallet.
  static HDWallet importWallet(String mnemonic) {
    return HDWallet.createWithMnemonic(mnemonic);
  }

  /// Creates a wallet using a mnemonic phrase.
  ///
  /// [mnemonic] is the mnemonic phrase of the wallet.
  /// Returns the created HDWallet.
  static HDWallet createWalletWithMnemonic(String mnemonic) {
    return HDWallet.createWithMnemonic(mnemonic);
  }

  /// Imports a wallet using a private key.
  ///
  /// [privateKey] is the private key in hex format.
  /// [coinType] specifies the type of the coin.
  /// Returns the address associated with the private key.
  static String importWalletWithPrivateKey(String privateKey,
      {int coinType = Constants.defaultCoinType}) {
    try {
      final bytes = hex.decode(privateKey); // Decode the hex string to bytes
      final pk = PrivateKey.createWithData(
          Uint8List.fromList(bytes)); // Create a PrivateKey object
      final publicKey = pk.getPublicKeySecp256k1(false); // Get the public key
      final anyAddress = AnyAddress.createWithPublicKey(
          publicKey, coinType); // Create an AnyAddress object
      return anyAddress.description(); // Return the address description
    } catch (e) {
      // Handle potential errors
      throw Exception('Invalid private key or unsupported coin type');
    }
  }

  /// Retrieves the private key for a specific coin type.
  ///
  /// [wallet] is the HDWallet object.
  /// [coinType] specifies the type of the coin.
  /// Returns the private key in hex format.
  static String getPrivateKey(HDWallet wallet,
      {int coinType = Constants.defaultCoinType}) {
    return hex.encode(wallet
        .getKeyForCoin(coinType)
        .data()); // Encode the private key to hex format
  }

  static String storedKey(String name, String password, String privateKey,
      {int coinType = Constants.defaultCoinType}) {
    var byte = Uint8List.fromList(hex.decode(privateKey));
    StoredKey? storedKey =
        StoredKey.importPrivateKey(byte, name, password, coinType);

    print('storedKey: $storedKey');
    return storedKey?.exportJson() ?? '';
  }

  static StoredKey? loadStoredKey(String path) {
    return StoredKey.load(path);
  }

  static StoredKey? importStoredKey(String json) {
    return StoredKey.importJson(json);
  }
}
