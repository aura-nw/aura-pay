import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:trust_wallet_core/protobuf/Ethereum.pb.dart' as Ethereum;
import 'package:wallet_core/src/constants/constants.dart';
import 'package:wallet_core/wallet_core.dart';

class EvmChains {
  static sendTransaction(AWallet wallet, String toAddress, BigInt amount,
      BigInt gasPrice, BigInt gasLimit, BigInt nonce,
      {int coinType = Constants.defaultCoinType}) {
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

    final output = Ethereum.SigningOutput.fromBuffer(
      AnySigner.sign(signingInput.writeToBuffer(), coin).toList(),
    );

    print('Transaction JSON: ${output.encoded}');
  }

  static List<int> _bigIntToBytes(BigInt number) {
    final byteData = ByteData(32);
    final bigIntBytes =
        number.toUnsigned(256).toRadixString(16).padLeft(64, '0');
    final bytes = hex.decode(bigIntBytes);
    byteData.buffer.asUint8List().setRange(32 - bytes.length, 32, bytes);
    return byteData.buffer.asUint8List();
  }
}
