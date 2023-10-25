import 'package:aura_wallet_core/aura_wallet_core.dart';

abstract interface class WalletRepository {
  Future<AuraWallet> createWallet({
    required String walletName,
  });

  Future<AuraWallet> importWallet({
    required String privateKeyOrPassPhrase,
    required String walletName,
  });

  Future<void> removeWallet({
    required String walletName,
  });
}
