import 'package:domain/src/domain/entities/pyxis_wallet.dart';
import 'package:domain/src/domain/repository/wallet_repository.dart';

final class WalletUseCase {
  final WalletRepository _walletProvider;

  const WalletUseCase(this._walletProvider);

  Future<PyxisWallet> createWallet() async {
    return _walletProvider.createWallet();
  }

  Future<PyxisWallet> importWallet({
    required String privateKeyOrPassPhrase,
  }) async {
    return _walletProvider.importWallet(
      privateKeyOrPassPhrase: privateKeyOrPassPhrase,
    );
  }

  Future<void> removeWallet() async {
    return _walletProvider.removeWallet();
  }
}
