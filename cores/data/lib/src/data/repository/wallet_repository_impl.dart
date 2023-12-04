import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:data/src/data/resource/provider/provider.dart';
import 'package:domain/domain.dart';

final class WalletRepositoryImpl implements WalletRepository {
  final WalletProvider _walletService;

  const WalletRepositoryImpl(this._walletService);

  @override
  Future<AuraWallet> createWallet() async {
    return _walletService.createWallet();
  }

  @override
  Future<AuraWallet> importWallet({
    required String privateKeyOrPassPhrase,
  }) async {
    return _walletService.importWallet(
      passPhraseOrPrivateKey: privateKeyOrPassPhrase,
    );
  }

  @override
  Future<void> removeWallet() async {
    return _walletService.removeWallet();
  }
}
