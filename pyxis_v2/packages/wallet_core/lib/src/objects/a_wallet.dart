import 'package:convert/convert.dart';
import 'package:wallet_core/wallet_core.dart';

/// Class to hold wallet information.
class AWallet {
  final HDWallet? wallet;
  final String address;
  final PrivateKey _privateKey;
  final int coinType;

  AWallet(
      {this.wallet,
      required this.address,
      required PrivateKey privateKey,
      required this.coinType})
      : _privateKey = privateKey;

  String get privateKey {
    return hex.encode(_privateKey.data());
  }
}
