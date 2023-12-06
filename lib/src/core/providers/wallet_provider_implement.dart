import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/services.dart';

class WalletProviderImpl implements WalletProvider {
  final AuraWalletCore _auraWalletCore;

  WalletProviderImpl(this._auraWalletCore);
  @override
  Future<PyxisWallet> createWallet() async {
    AuraWallet auraWallet = await _auraWalletCore.createRandomHDWallet();
    return PyxisWalletImpl(auraWallet);
  }

  @override
  Future<PyxisWallet?> getCurrentWallet() async {
    AuraWallet? auraWallet = await _auraWalletCore.loadStoredWallet();
    if (auraWallet == null) {
      return null;
    }
    return PyxisWalletImpl(auraWallet);
  }

  @override
  Future<PyxisWallet> importWallet(
      {required String privateKeyOrPassPhrase}) async {
    AuraWallet auraWallet = await _auraWalletCore.restoreHDWallet(
        passPhraseOrPrivateKey: privateKeyOrPassPhrase);
    return PyxisWalletImpl(auraWallet);
  }

  @override
  Future<void> removeWallet() {
    return _auraWalletCore.removeWallet();
  }
}

class PyxisWalletImpl implements PyxisWallet {
  final AuraWallet _auraWallet;

  PyxisWalletImpl(this._auraWallet);

  @override
  String get bech32Address => _auraWallet.bech32Address;

  @override
  String? get mnemonic => _auraWallet.mnemonic;

  @override
  String? get privateKey => _auraWallet.privateKey;

  @override
  Uint8List get publicKey => _auraWallet.publicKey;
}
