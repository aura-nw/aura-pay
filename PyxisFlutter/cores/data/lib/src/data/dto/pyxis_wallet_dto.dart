import 'package:domain/domain.dart';

abstract class PyxisWalletDto extends PyxisWallet {
  const PyxisWalletDto({
    required super.bech32Address,
    required super.publicKey,
    super.mnemonic,
    super.privateKey,
  });
}
