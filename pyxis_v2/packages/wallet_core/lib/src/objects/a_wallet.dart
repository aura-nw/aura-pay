import 'package:wallet_core/wallet_core.dart';

/// Class to hold wallet information.
class AWallet {
  final HDWallet? wallet;
  final String address;
  final String privateKey;

  AWallet({this.wallet, required this.address, required this.privateKey});
}
