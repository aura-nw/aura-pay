import 'package:aura_wallet_core/aura_wallet_core.dart';

final class WalletProvider {
  final AuraWalletCore _auraWalletCore;

  const WalletProvider(this._auraWalletCore);

  Future<AuraWallet> createWallet() async {
    return _auraWalletCore.createRandomHDWallet();
  }

  Future<AuraWallet> importWallet({
    required String passPhraseOrPrivateKey,
  }) async {
    return _auraWalletCore.restoreHDWallet(
      passPhraseOrPrivateKey: passPhraseOrPrivateKey,
    );
  }

  Future<void> removeWallet() async {
    return _auraWalletCore.removeWallet();
  }

  Future<AuraWallet?> getCurrentWallet() async {
    return _auraWalletCore.loadStoredWallet();
  }
}
