import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

sealed class AuraTransactionHelper {
  static const String spenderKey = 'spender';
  static const String amountKey = 'amount';

  static String getAttributeAmount(PyxisTransactionEvent event) {
    return event.values
            .firstWhereOrNull(
              (element) => element.key == amountKey,
            )
            ?.value ??
        '';
  }

  static String getAttributeSpender(PyxisTransactionEvent event) {
    return event.values
            .firstWhereOrNull(
              (element) => element.key == spenderKey,
            )
            ?.value ??
        '';
  }
}
