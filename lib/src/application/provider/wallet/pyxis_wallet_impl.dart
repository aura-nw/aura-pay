import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

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
  Future sendTransaction({
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

    return tx;
  }

  @override
  Future<SendTransactionInformation> submitTransaction<P>(
      {required P signedTransaction}) async {
    final response = await _auraWallet.submitTransaction(
      signedTransaction: signedTransaction as dynamic,
    );

    return SendTransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
    ).toEntity;
  }
}
