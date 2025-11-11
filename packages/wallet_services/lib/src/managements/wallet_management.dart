import 'dart:typed_data';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:wallet_services/src/constants/constants.dart';
import 'package:wallet_services/wallet_services.dart';

class WalletManagement {
  /// Generates a random mnemonic phrase with error handling for TrustWalletCore stability.
  ///
  /// [strength] determines the strength of the mnemonic phrase.
  /// [passphrase] is an optional passphrase to use with the mnemonic.
  /// [waitForCryptoInit] if true, waits for crypto initialization on Android (recommended)
  /// Returns the generated mnemonic phrase.
  /// 
  /// Throws an exception if wallet generation fails.
  String randomMnemonic({
    int strength = 128, 
    String passphrase = '',
    bool waitForCryptoInit = true,
  }) {
    try {
      // On Android, add a small delay to ensure entropy pool is ready
      if (Platform.isAndroid && waitForCryptoInit) {
        // Synchronous delay using busy-wait (not ideal but necessary for sync method)
        final stopwatch = Stopwatch()..start();
        while (stopwatch.elapsedMilliseconds < 200) {
          // Small delay to let native crypto initialize
        }
      }
      
      final wallet = HDWallet(strength: strength, passphrase: passphrase);
      final mnemonic = wallet.mnemonic();
      
      // Validate that mnemonic is not empty
      if (mnemonic.isEmpty) {
        throw Exception('Generated mnemonic is empty');
      }
      
      return mnemonic;
    } catch (e) {
      throw Exception('Failed to generate mnemonic: $e. This may be due to TrustWalletCore initialization issues. Please try restarting the app.');
    }
  }

  /// Generates a random HDWallet with error handling for TrustWalletCore stability.
  ///
  /// [strength] determines the strength of the mnemonic phrase.
  /// [passphrase] is an optional passphrase to use with the mnemonic.
  /// [waitForCryptoInit] if true, waits for crypto initialization on Android (recommended)
  /// Returns the generated HDWallet.
  /// 
  /// Throws an exception if wallet generation fails.
  HDWallet randomWallet({
    int strength = 128, 
    String passphrase = '',
    bool waitForCryptoInit = true,
  }) {
    try {
      // On Android, add a small delay to ensure entropy pool is ready
      if (Platform.isAndroid && waitForCryptoInit) {
        // Synchronous delay using busy-wait (not ideal but necessary for sync method)
        final stopwatch = Stopwatch()..start();
        while (stopwatch.elapsedMilliseconds < 200) {
          // Small delay to let native crypto initialize
        }
      }
      
      final wallet = HDWallet(strength: strength, passphrase: passphrase);
      
      // Validate wallet by attempting to get mnemonic
      final mnemonic = wallet.mnemonic();
      if (mnemonic.isEmpty) {
        throw Exception('Generated wallet has empty mnemonic');
      }
      
      return wallet;
    } catch (e) {
      throw Exception('Failed to generate wallet: $e. This may be due to TrustWalletCore initialization issues. Please try restarting the app.');
    }
  }

  /// Imports a wallet using a mnemonic phrase.
  ///
  /// [mnemonic] is the mnemonic phrase of the wallet.
  /// Returns the AWallet containing the HDWallet and address.
  AWallet importWallet(
    String mnemonic, {
    int coinType = Constants.defaultCoinType,
  }) {
    final wallet = HDWallet.createWithMnemonic(mnemonic);
    final address = wallet.getAddressForCoin(coinType);

    return AWallet(
      wallet: wallet,
      address: address,
      privateKey: wallet.getKeyForCoin(
        coinType,
      ),
      coinType: coinType,
    );
  }

  /// Imports a wallet using a private key.
  ///
  /// [privateKey] is the private key in hex format.
  /// [coinType] specifies the type of the coin.
  /// Returns the AWallet containing the address and private key.
  AWallet importWalletWithPrivateKey(
    String privateKey, {
    int coinType = Constants.defaultCoinType,
  }) {
    try {
      final bytes = hex.decode(privateKey); // Decode the hex string to bytes
      final pk = PrivateKey.createWithData(
          Uint8List.fromList(bytes)); // Create a PrivateKey object

      PublicKey publicKey;

      switch (coinType) {
        case Constants.defaultCoinType:
          publicKey = pk.getPublicKeySecp256k1(false); // Get the public key
        case Constants.cosmosCoinType:
          publicKey = pk.getPublicKeySecp256k1(true);
        default:
          publicKey = pk.getPublicKeySecp256k1(false); // Get the public key
          break;
      }

      final anyAddress = AnyAddress.createWithPublicKey(
          publicKey, coinType); // Create an AnyAddress object
      final address = anyAddress.description(); // Get the address description

      return AWallet(
          wallet: null, address: address, privateKey: pk, coinType: coinType);
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
  String getPrivateKey(HDWallet wallet,
      {int coinType = Constants.defaultCoinType}) {
    return hex.encode(wallet
        .getKeyForCoin(coinType)
        .data()); // Encode the private key to hex format
  }
}
