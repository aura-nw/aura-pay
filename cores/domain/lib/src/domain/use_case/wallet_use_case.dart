import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/src/domain/repository/wallet_repository.dart';

final class WalletUseCase {
  final WalletRepository _repository;

  const WalletUseCase(this._repository);

  Future<AuraWallet> createWallet() async {
    return _repository.createWallet();
  }

  Future<AuraWallet> importWallet({
    required String privateKeyOrPassPhrase,
  }) async {
    return _repository.importWallet(
      privateKeyOrPassPhrase: privateKeyOrPassPhrase,
    );
  }

  Future<void> removeWallet() async {
    return _repository.removeWallet();
  }
}
