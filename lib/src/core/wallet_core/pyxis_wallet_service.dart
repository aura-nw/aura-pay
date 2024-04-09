import 'package:aura_wallet_core/aura_chain_helper.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:aura_wallet_core/config_options/environment_options.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/wallet_core/entities/tx_data.dart';
import 'package:pyxis_mobile/src/core/wallet_core/pyxis_wallet_core.dart';

class PyxisWalletService {
  static Future<TxData> makeTransaction({
    required String privateKeyOrPasspharse,
    required String toAddress,
    required String amount,
    required String fee,
    required int gasLimit,
    required PyxisEnvironment environment,
    String? memo,
  }) async {
    try {
      AuraEnvironment auraEnvironment =
          PyxisWalletCore.toWalletCoreE(environment);

      Tx tx = await AuraChainHelper.makeATransaction(
        privateKeyOrPasspharse: privateKeyOrPasspharse,
        toAddress: toAddress,
        amount: amount,
        fee: fee,
        gasLimit: gasLimit,
        memo: memo,
        auraNetworkInfo: auraEnvironment.getNetworkInfo,
      );

      return TxData(tx);
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }

  static Future<TransactionInformation> submitTransaction(
      {required TxData signedTransaction,
      required PyxisEnvironment environment}) async {
    AuraEnvironment auraEnvironment =
        PyxisWalletCore.toWalletCoreE(environment);

    final response = await AuraChainHelper.submitTransaction(
        signedTransaction: signedTransaction.tx,
        auraNetworkInfo: auraEnvironment.getNetworkInfo);

    return TransactionInformationDto(
      txHash: response.txhash,
      timestamp: response.timestamp,
      status: response.code,
      rawLog: response.rawLog,
    ).toEntity;
  }
}
