import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:data/src/data/resource/provider/provider.dart';
import 'package:domain/domain.dart';

final class WalletRepositoryImpl implements WalletRepository {
  final WalletProvider _walletService;

  const WalletRepositoryImpl(this._walletService);

  @override
  Future<AuraWallet> createWallet({required String walletName}) async {
    return _walletService.createWallet(walletName: walletName);
  }

  @override
  Future<AuraWallet> importWallet(
      {required String privateKeyOrPassPhrase,
      required String walletName}) async {
    return _walletService.importWallet(
      passPhraseOrPrivateKey: privateKeyOrPassPhrase,
      walletName: walletName,
    );
  }

  @override
  Future<void> removeWallet({required String walletName}) async {
    return _walletService.removeWallet(
      walletName: walletName,
    );
  }
}
