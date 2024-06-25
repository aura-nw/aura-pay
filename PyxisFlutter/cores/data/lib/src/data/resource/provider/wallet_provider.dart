import 'package:domain/domain.dart';

abstract interface class WalletProvider {
  Future<PyxisWallet> createWallet();

  Future<PyxisWallet> importWallet({
    required String privateKeyOrPassPhrase,
  });

  Future<void> removeWallet();

  Future<PyxisWallet?> getCurrentWallet();
}
