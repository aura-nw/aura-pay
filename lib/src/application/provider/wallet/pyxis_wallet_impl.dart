import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:data/data.dart';

class PyxisWalletImpl extends PyxisWalletDto {
  final AuraWallet _auraWallet;

  const PyxisWalletImpl(
    this._auraWallet, {
    required super.bech32Address,
    required super.publicKey,
    super.mnemonic,
    super.privateKey,
  });

  @override
  Future<String> checkWalletBalance() async {
    return _auraWallet.checkWalletBalance();
  }

  @override
  Future<T> sendTransaction<T>({
    required String toAddress,
    required String amount,
    required String fee,
    required int gasLimit,
    String? memo,
  }) async {
    final tx = await _auraWallet.sendTransaction(
      toAddress: toAddress,
      amount: amount,
      fee: fee,
      gasLimit: gasLimit,
      memo: memo,
    );

    return tx as T;
  }

  @override
  Future<bool> submitTransaction<P>({required P signedTransaction}) async {
    return _auraWallet.submitTransaction(
      signedTransaction: signedTransaction as dynamic,
    );
  }
}
