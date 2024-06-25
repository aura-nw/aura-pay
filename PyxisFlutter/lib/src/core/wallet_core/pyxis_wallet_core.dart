import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:aura_wallet_core/config_options/environment_options.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/application/provider/wallet/pyxis_wallet_impl.dart';

class PyxisWalletCore {
  final PyxisEnvironment environment;
  late AuraWalletCore _auraWalletCore;

  PyxisWalletCore({required this.environment}) {
    final AuraEnvironment auraEnvironment = toWalletCoreE(environment);
    _auraWalletCore = AuraWalletCore.create(environment: auraEnvironment);
  }

  static AuraEnvironment toWalletCoreE(PyxisEnvironment environment) {
    int index = environment.index;
    return AuraEnvironment.values[index];
  }

  Future<PyxisWallet> createRandomHDWallet({
    String walletName = 'AuraWallet',
  }) async {
    // throw UnimplementedError();
    final AuraWallet auraWallet = await _auraWalletCore.createRandomHDWallet();

    return PyxisWalletImpl(
      auraWallet,
      bech32Address: auraWallet.bech32Address,
      publicKey: auraWallet.publicKey,
      privateKey: auraWallet.privateKey,
      mnemonic: auraWallet.mnemonic,
    );
  }

  Future<PyxisWallet?> loadStoredWallet() async {
    // throw UnimplementedError();
    final AuraWallet? auraWallet = await _auraWalletCore.loadStoredWallet();

    if (auraWallet == null) return null;

    return PyxisWalletImpl(
      auraWallet,
      bech32Address: auraWallet.bech32Address,
      publicKey: auraWallet.publicKey,
      privateKey: auraWallet.privateKey,
      mnemonic: auraWallet.mnemonic,
    );
  }

  restoreHDWallet({required String passPhraseOrPrivateKey}) async {
    // throw UnimplementedError();
    final AuraWallet auraWallet = await _auraWalletCore.restoreHDWallet(
      passPhraseOrPrivateKey: passPhraseOrPrivateKey,
    );

    return PyxisWalletImpl(
      auraWallet,
      bech32Address: auraWallet.bech32Address,
      publicKey: auraWallet.publicKey,
    );
  }

  Future<void> removeWallet() {
    // throw UnimplementedError();
    return _auraWalletCore.removeWallet();
  }
}
