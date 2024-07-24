import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:http/http.dart';
import 'package:trust_wallet_core/protobuf/Ethereum.pb.dart' as Ethereum;
import 'package:wallet_core/src/constants/constants.dart';
import 'package:wallet_core/src/extensions/bigint_extension.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class EvmChainClient {
  final ChainInfo chainInfo;
  final Web3Client _web3client;

  EvmChainClient(this.chainInfo)
      : _web3client = Web3Client(chainInfo.rpcUrl, Client());

  Future<BigInt> getWalletBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    final balance = await _web3client.getBalance(ethAddress);
    return balance.getInWei;
  }

  Future<String?> sendTransaction(
      {required AWallet wallet,
      required String toAddress,
      required BigInt amount,
      required BigInt gasPrice,
      required BigInt gasLimit,
      int coinType = Constants.defaultCoinType}) async {
    try {
      BigInt chainId = await _web3client.getChainId();

      // Input your recipient address
      const String recipientAddress = '';

      Ethereum.SigningInput signingInput = Ethereum.SigningInput(
        toAddress: recipientAddress,
        privateKey: wallet.privateKeyData,
        chainId: chainId.toUin8List(),
        gasPrice: gasPrice.toUin8List(),
        gasLimit: gasLimit.toUin8List(),
        transaction: Ethereum.Transaction(
          transfer: Ethereum.Transaction_Transfer(
            amount: amount.toUin8List(),
          ),
        ),
      );

      final Uint8List signBytes = AnySigner.sign(
        signingInput.writeToBuffer(),
        coinType,
      );

      final outPut = Ethereum.SigningOutput.fromBuffer(signBytes);

      final String hash = await _web3client.sendRawTransaction(
        Uint8List.fromList(outPut.encoded),
      );

      print('receive transaction hash ${hash}');

      final TransactionInformation? tx =
          await _web3client.getTransactionByHash(hash);

      print('tx != null ${tx != null}');
      return hash;
    } catch (e) {
      print('receive error ${e.toString()}');
      return null;
    }
  }
}
