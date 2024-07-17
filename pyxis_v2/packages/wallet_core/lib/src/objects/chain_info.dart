import 'package:http/http.dart'; //You can also import the browser version
import 'package:web3dart/web3dart.dart';

class ChainInfo {
  final String rpcUrl;
  final String chainId;
  final String symbol;
  final String name;
  final String icon;
  late final Web3Client _web3client;

  ChainInfo(
      {required this.rpcUrl,
      required this.chainId,
      required this.symbol,
      required this.name,
      required this.icon}) {
    _web3client = Web3Client(rpcUrl, Client());
  }

  Future<BigInt> getWalletBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    final balance = await _web3client.getBalance(ethAddress);
    return balance.getInWei;
  }
}
