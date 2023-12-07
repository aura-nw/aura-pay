import 'package:domain/domain.dart';

abstract class WalletRepository {
  Future<PyxisWallet> createWallet();

  Future<PyxisWallet> importWallet({
    required String privateKeyOrPassPhrase,
  });

  Future<void> removeWallet();

  Future<PyxisWallet?> getCurrentWallet();
}
