import 'package:data/src/data/dto/dto.dart';

abstract interface class WalletProvider{
  Future<PyxisWalletDto> createWallet();

  Future<PyxisWalletDto> importWallet({
    required String privateKeyOrPassPhrase,
  });

  Future<void> removeWallet();

  Future<PyxisWalletDto?> getCurrentWallet();
}