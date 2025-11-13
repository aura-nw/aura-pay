import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:convert/convert.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:wallet_services/src/constants/constants.dart';
import 'package:wallet_services/wallet_services.dart';

String mnemonic = 'hen cat bread cry obey wrist click tunnel certain decade resemble muscle';

String privateKey = '0e63dd62f94699348a88dde6c075dd970b83d4091a03ad7c5b51adc95129c229';

String privateKey2 = '6bfc6e4afd58ce8cd1583f290f86ad2d0cbc7b9ab26201659337923856fdbb1c';

const type1 = TWCoinType.TWCoinTypeCosmos;

void test1(){
  final wallet = HDWallet.createWithMnemonic(mnemonic);

  final privateKey = wallet.getKeyForCoin(type1);

  developer.log(
    'private key 1 = ${hex.encode(privateKey.data())}',
    name: 'WalletUtils',
  );
  developer.log(
    'address 1 ${wallet.getAddressForCoin(type1)}',
    name: 'WalletUtils',
  );
}

void test2(){
  final wallet = HDWallet.createWithMnemonic(mnemonic);

  final privateKey = wallet.getKey(type1,Constants.derivationPathCosmos);

  developer.log(
    'private key 2 = ${hex.encode(privateKey.data())}',
    name: 'WalletUtils',
  );
  developer.log(
    'address 2 ${wallet.getAddressForCoin(type1)}',
    name: 'WalletUtils',
  );
}

void test3(){
  PrivateKey privateKeyCreate = PrivateKey.createWithData(Uint8List.fromList(hex.decode(privateKey)));

  final publicKey = privateKeyCreate.getPublicKeySecp256k1(true);

  final anyAddress = AnyAddress.createWithPublicKey(publicKey, type1);

  developer.log(
    'test 3 ${anyAddress.description()}',
    name: 'WalletUtils',
  );

  final data = bech32.makeBech32Decoder('cosmos', anyAddress.description());

  developer.log(
    'test 3 ${bech32.convertBech32AddressToEthAddress('cosmos', anyAddress.description())}',
    name: 'WalletUtils',
  );
  developer.log(
    'test 3 ${bech32.makeBech32Encoder('aura', data)}',
    name: 'WalletUtils',
  );



  developer.log(
    'add ${bech32.makeBech32Encoder('aura', anyAddress.data())}',
    name: 'WalletUtils',
  );
  developer.log(
    'address ${bech32.convertBech32AddressToEthAddress('aura',bech32.makeBech32Encoder('aura', anyAddress.data()))}',
    name: 'WalletUtils',
  );
}

void test4(){
  PrivateKey privateKeyCreate = PrivateKey.createWithData(Uint8List.fromList(hex.decode(privateKey2)));

  final publicKey = privateKeyCreate.getPublicKeySecp256k1(false);

  final anyAddress = AnyAddress.createWithPublicKey(publicKey, TWCoinType.TWCoinTypeEthereum);

  developer.log(
    'test 4 ${bech32.makeBech32Encoder('aura', anyAddress.data())}',
    name: 'WalletUtils',
  );
  developer.log(
    'test 4 ${anyAddress.description()}',
    name: 'WalletUtils',
  );

}

void test5(){
  final wallet = HDWallet.createWithMnemonic(mnemonic);

  final privateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum);

  developer.log(
    'test 5 = ${hex.encode(privateKey.data())}',
    name: 'WalletUtils',
  );
  developer.log(
    'test 5 ${wallet.getAddressForCoin(TWCoinType.TWCoinTypeEthereum)}',
    name: 'WalletUtils',
  );
}