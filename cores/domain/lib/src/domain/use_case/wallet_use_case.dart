import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/src/domain/repository/wallet_repository.dart';

final class WalletUseCase {
  final WalletRepository _repository;

  const WalletUseCase(this._repository);

  Future<AuraWallet> createWallet({
    required String walletName,
  }) async {
    return _repository.createWallet(
      walletName: walletName,
    );
  }

  Future<AuraWallet> importWallet({
    required String privateKeyOrPassPhrase,
    required String walletName,
  }) async {
    return _repository.importWallet(
      privateKeyOrPassPhrase: privateKeyOrPassPhrase,
      walletName: walletName,
    );
  }

  Future<void> removeWallet({
    required String walletName,
  }) async {
    return _repository.removeWallet(
      walletName: walletName,
    );
  }
}
