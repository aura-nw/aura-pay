import 'package:aura_wallet_core/aura_wallet_core.dart';

final class WalletProvider {
  final AuraWalletCore _auraWalletCore;

  const WalletProvider(this._auraWalletCore);

  Future<AuraWallet> createWallet({
    required String walletName,
  }) async {
    return _auraWalletCore.createRandomHDWallet(
      walletName: walletName,
    );
  }

  Future<AuraWallet> importWallet({
    required String passPhraseOrPrivateKey,
    required String walletName,
  }) async {
    return _auraWalletCore.restoreHDWallet(
      passPhraseOrPrivateKey: passPhraseOrPrivateKey,
      walletName: walletName,
    );
  }

  Future<void> removeWallet({
    required String walletName,
  }) async {
    return _auraWalletCore.removeWallet(
      walletName: walletName,
    );
  }

  Future<AuraWallet?> getCurrentWallet({
    required String walletName,
  }) async {
    return _auraWalletCore.loadStoredWallet(
      walletName: walletName,
    );
  }
}
