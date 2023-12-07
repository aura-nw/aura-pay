import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:data/data.dart';
import 'package:pyxis_mobile/src/application/provider/wallet/pyxis_wallet_impl.dart';

final class WalletProviderImpl implements WalletProvider {
  final AuraWalletCore _auraWalletCore;

  const WalletProviderImpl(
    this._auraWalletCore,
  );

  @override
  Future<PyxisWalletDto> createWallet() async {
    final auraWallet = await _auraWalletCore.createRandomHDWallet();

    return PyxisWalletImpl(
      auraWallet,
      bech32Address: auraWallet.bech32Address,
      publicKey: auraWallet.publicKey,
      privateKey: auraWallet.privateKey,
      mnemonic: auraWallet.mnemonic,
    );
  }

  @override
  Future<PyxisWalletDto?> getCurrentWallet() async {
    final auraWallet = await _auraWalletCore.loadStoredWallet();

    if (auraWallet == null) return null;

    return PyxisWalletImpl(
      auraWallet,
      bech32Address: auraWallet.bech32Address,
      publicKey: auraWallet.publicKey,
      privateKey: auraWallet.privateKey,
      mnemonic: auraWallet.mnemonic,
    );
  }

  @override
  Future<PyxisWalletDto> importWallet({
    required String privateKeyOrPassPhrase,
  }) async {
    final auraWallet = await _auraWalletCore.restoreHDWallet(
      passPhraseOrPrivateKey: privateKeyOrPassPhrase,
    );

    return PyxisWalletImpl(
      auraWallet,
      bech32Address: auraWallet.bech32Address,
      publicKey: auraWallet.publicKey,
    );
  }

  @override
  Future<void> removeWallet() {
    return _auraWalletCore.removeWallet();
  }
}
