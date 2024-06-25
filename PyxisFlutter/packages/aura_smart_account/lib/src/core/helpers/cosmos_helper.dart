import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_smart_account/src/core/constants/smart_account_error_code.dart';
import 'package:aura_smart_account/src/core/definitions/gas_price.dart';
import 'package:aura_smart_account/src/proto/cosmos/base/v1beta1/export.dart'
    as base;
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:decimal/decimal.dart';

import 'package:fixnum/fixnum.dart' as $fixnum;

sealed class CosmosHelper {
  ///Calculate std fee for a Aura transaction
  /// See more [https://github.com/cosmos/cosmjs/blob/main/packages/stargate/src/fee.ts]
  static tx.Fee calculateFee(
    int gasEstimation, {
    required String deNom,
    double ?gasPrice,
  }) {
    //set default for multi gas
    const double multiGas = 1.6;

    // Set default gas price is average gas price
    gasPrice??= GasPriceStep.average.value;

    // Create gas price from gasPrice and denom
    String gasPriceString = '$gasPrice$deNom';

    final Decimal gasPriceAmount = _getDecimalAmountFromString(gasPriceString);

    final int gasLimit = (gasEstimation * multiGas).round();

    final String amount =
        (gasPriceAmount * Decimal.fromInt(gasLimit)).ceil().toString();

    return tx.Fee.create()
      ..gasLimit = $fixnum.Int64(
        gasLimit,
      )
      ..amount.add(
        base.Coin.create()
          ..denom = deNom
          ..amount = amount,
      );
  }

  static Decimal _getDecimalAmountFromString(String gasPrice) {
    final RegExpMatch? matchResult =
        RegExp(r'^([0-9.]+)([a-z][a-z0-9]*)$', caseSensitive: false)
            .firstMatch(gasPrice);

    if (matchResult == null) {
      throw AuraSmartAccountError(
        code: SmartAccountErrorCode.errorCodeFormatPrice,
        errorMsg: 'Invalid gas price string',
      );
    }

    final String amount = matchResult.group(1) ?? '';

    final Decimal decimalAmount = Decimal.tryParse(amount) ?? Decimal.zero;

    return decimalAmount;
  }
}
