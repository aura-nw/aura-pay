import 'package:data/src/data/resource/provider/provider.dart';
import 'package:domain/domain.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletProvider _walletProvider;

  const WalletRepositoryImpl(this._walletProvider);

  @override
  Future<PyxisWallet> createWallet() async {
    return _walletProvider.createWallet();
  }

  @override
  Future<PyxisWallet?> getCurrentWallet() async {
    return _walletProvider.getCurrentWallet();
  }

  @override
  Future<PyxisWallet> importWallet({required String privateKeyOrPassPhrase}) {
    return _walletProvider.importWallet(
      privateKeyOrPassPhrase: privateKeyOrPassPhrase,
    );
  }

  @override
  Future<void> removeWallet() {
    return _walletProvider.removeWallet();
  }
}
