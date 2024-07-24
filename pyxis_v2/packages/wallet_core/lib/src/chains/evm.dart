import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:trust_wallet_core/protobuf/Ethereum.pb.dart' as Ethereum;
import 'package:wallet_core/src/constants/constants.dart';
import 'package:wallet_core/wallet_core.dart';

class EvmChains {
  static Future<String> sendTransaction(
      AWallet wallet,
      String toAddress,
      BigInt amount,
      BigInt gasPrice,
      BigInt gasLimit,
      BigInt nonce,
      ChainInfo chainInfo,
      {int coinType = Constants.defaultCoinType}) {
    final output = makeSendTransaction(
      wallet,
      toAddress,
      amount,
      gasPrice,
      gasLimit,
      nonce,
      coinType,
    );
    return chainInfo.submitTransaction(Uint8List.fromList(output.encoded));
  }

  static Ethereum.SigningOutput makeSendTransaction(
      AWallet wallet,
      String toAddress,
      BigInt amount,
      BigInt gasPrice,
      BigInt gasLimit,
      BigInt nonce,
      int coinType) {
    int coin = TWCoinType.TWCoinTypeEthereum;
    final privateKey = wallet.privateKeyData;

    final signingInput = Ethereum.SigningInput(
      chainId: _bigIntToBytes(BigInt.from(1)), // Mainnet
      nonce: _bigIntToBytes(nonce),
      gasPrice: _bigIntToBytes(gasPrice),
      gasLimit: _bigIntToBytes(gasLimit),
      toAddress: toAddress,
      privateKey: privateKey,
      transaction: Ethereum.Transaction(
        transfer: Ethereum.Transaction_Transfer(
          amount: _bigIntToBytes(amount),
        ),
      ),
    );

    final Ethereum.SigningOutput output = Ethereum.SigningOutput.fromBuffer(
      AnySigner.sign(signingInput.writeToBuffer(), coin).toList(),
    );

    print('address: ${wallet.address}');
    print('toAddress: $toAddress');
    print('Transaction JSON: ${output.encoded}');
    print('Transaction Hash: ${output.errorMessage}');
    return output;
  }

  static List<int> _bigIntToBytes(BigInt number) {
    final byteData = ByteData(32);
    final bigIntBytes =
        number.toUnsigned(256).toRadixString(16).padLeft(64, '0');
    final bytes = hex.decode(bigIntBytes);
    byteData.buffer.asUint8List().setRange(32 - bytes.length, 32, bytes);
    return byteData.buffer.asUint8List();
  }

  static _submitTransaction(
      ChainInfo chainInfo, Ethereum.SigningOutput transaction) {}
}
