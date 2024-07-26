import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:trust_wallet_core/protobuf/Ethereum.pb.dart' as Ethereum;
import 'package:wallet_core/src/extensions/bigint_extension.dart';
import 'package:wallet_core/wallet_core.dart';
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

  Future<String> sendTransaction({
    required Uint8List rawTransaction,
  }) async {
    final String hash = await _web3client.sendRawTransaction(
      Uint8List.fromList(rawTransaction),
    );

    return hash;
  }

  Future<TransactionReceipt> verifyTransaction({
    required String hash,
    int times = 0,
  }) async {
    try {
      await Future.delayed(
        const Duration(
          milliseconds: 2100,
        ),
      );
      final TransactionReceipt? tx =
          await _web3client.getTransactionReceipt(hash);

      if (tx == null) {
        throw Exception('Transaction execute failed');
      }

      return tx;
    } catch (e) {
      if (times == 5) {
        rethrow;
      }
      return verifyTransaction(
        hash: hash,
        times: times + 1,
      );
    }
  }

  Future<Uint8List> createTransaction({
    required AWallet wallet,
    required String toAddress,
    required BigInt amount,
    required BigInt gasLimit,
    required String recipient,
  }) async {
    final BigInt chainId = await _web3client.getChainId();

    final EtherAmount gasPrice = await _web3client.getGasPrice();

    Ethereum.SigningInput signingInput = Ethereum.SigningInput(
      toAddress: recipient,
      privateKey: wallet.privateKeyData,
      chainId: chainId.toUin8List(),
      gasPrice: gasPrice.getInWei.toUin8List(),
      gasLimit: gasLimit.toUin8List(),
      transaction: Ethereum.Transaction(
        transfer: Ethereum.Transaction_Transfer(
          amount: amount.toUin8List(),
        ),
      ),
    );

    final Uint8List signBytes = AnySigner.sign(
      signingInput.writeToBuffer(),
      TWCoinType.TWCoinTypeEthereum,
    );

    final outPut = Ethereum.SigningOutput.fromBuffer(signBytes);

    return Uint8List.fromList(outPut.encoded);
  }

  Future<BigInt> estimateGas({required Uint8List rawTransaction}) async {
    return _web3client.estimateGas(
      data: rawTransaction,
    );
  }
}
