library wallet_core;

import 'package:convert/convert.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:trust_wallet_core/trust_wallet_core_ffi.dart';
export 'package:trust_wallet_core/trust_wallet_core_ffi.dart';
export 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
export 'package:trust_wallet_core/trust_wallet_core.dart';

class logger {
  static d(String message) {
    print(message);
  }

}

class WalletCore {
  static init () {
    FlutterTrustWalletCore.init();
  }
  static HDWallet createWallet() {
    
     String mnemonic = "rent craft script crucial item someone dream federal notice page shrug pipe young hover duty"; // 有测试币的 tron地址
    var wallet = HDWallet.createWithMnemonic(mnemonic);

     logger.d("address ${wallet.getAddressForCoin(60)}");
    logger.d("mnemonic = ${wallet.mnemonic()}");
    print(wallet.mnemonic());
    String privateKeyhex = hex.encode(wallet.getKeyForCoin(60).data());
    // String privateKey0 = hex.encode(wallet.getDerivedKey(60,0,0,0).data());
    // String privateKey1 = hex.encode(wallet.getDerivedKey(60,0,0,1).data());
    logger.d("privateKeyhex = $privateKeyhex");
    // logger.d("privateKeyhex0 = $privateKey0");
    // logger.d("privateKeyhex1 = $privateKey1");
    logger.d("seed = ${hex.encode(wallet.seed())}");
    final a = StoredKey.importPrivateKey(wallet.getKeyForCoin(60).data(), "", "123", 60);
    logger.d("keystore a = ${a?.exportJson()}");

    final publicKey = wallet.getKeyForCoin(60).getPublicKeySecp256k1(false);
    final anyAddress = AnyAddress.createWithPublicKey(publicKey, 60);

    logger.d("1 = ${AnyAddress.isValid("0xfaC5482fffe86d33c3b8ADB24F839F5e60aF99d4", TWCoinType.TWCoinTypeEthereum)}");
    logger.d("2 = ${AnyAddress.isValid("0xfaC5482fffe86d33c3b8ADB24F839F5e60af99d4", TWCoinType.TWCoinTypeEthereum)}");
    logger.d("3 = ${AnyAddress.isValid("faC5482fffe86d33c3b8ADB24F839F5e60af99d4", TWCoinType.TWCoinTypeEthereum)}");
    final privakye = wallet.getKey(60, "m/49'/60'/0'/0/0");
    final publicKey1 = privakye.getPublicKeySecp256k1(true);
    final address = AnyAddress.createWithPublicKey(publicKey1, 0);


    return wallet;

  }
}