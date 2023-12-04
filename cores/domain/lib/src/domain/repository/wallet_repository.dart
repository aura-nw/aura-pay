import 'package:aura_wallet_core/aura_wallet_core.dart';

abstract interface class WalletRepository {
  Future<AuraWallet> createWallet();

  Future<AuraWallet> importWallet({
    required String privateKeyOrPassPhrase,
  });

  Future<void> removeWallet();
}
