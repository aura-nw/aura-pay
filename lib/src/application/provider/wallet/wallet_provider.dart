import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/wallet_core/pyxis_wallet_core.dart';

final class WalletProviderImpl implements WalletProvider {
  final PyxisWalletCore _auraWalletCore;

  const WalletProviderImpl(
    this._auraWalletCore,
  );

  @override
  Future<PyxisWallet> createWallet() async {
    final PyxisWallet auraWallet = await _auraWalletCore.createRandomHDWallet();
    return auraWallet;
  }

  @override
  Future<PyxisWallet?> getCurrentWallet() async {
    return _auraWalletCore.loadStoredWallet();
  }

  @override
  Future<PyxisWallet> importWallet({
    required String privateKeyOrPassPhrase,
  }) async {
    final PyxisWallet auraWallet = await _auraWalletCore.restoreHDWallet(
      passPhraseOrPrivateKey: privateKeyOrPassPhrase,
    );

    return auraWallet;
  }

  @override
  Future<void> removeWallet() {
    return _auraWalletCore.removeWallet();
  }
}
