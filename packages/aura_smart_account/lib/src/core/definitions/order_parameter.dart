import 'package:aura_smart_account/src/core/constants/smart_account_constant.dart';
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;

enum AuraSmartAccountOrder {
  ORDER_BY_UNSPECIFIED,
  ORDER_BY_ASC,
  ORDER_BY_DESC,
}

extension AuraSmartAccountOrderGetter on String {
  AuraSmartAccountOrder get fromString {
    switch (this) {
      case 'ORDER_BY_ASC':
        return AuraSmartAccountOrder.ORDER_BY_ASC;
      case 'ORDER_BY_DESC':
        return AuraSmartAccountOrder.ORDER_BY_DESC;
      case 'ORDER_BY_UNSPECIFIED':
        return AuraSmartAccountOrder.ORDER_BY_UNSPECIFIED;

      default:
        return AuraSmartAccountOrder.ORDER_BY_ASC;
    }
  }
}

final class OrderParameter {
  final AuraSmartAccountOrder orderBy;
  final int limit;
  final int offset;

  const OrderParameter({
    this.offset = AuraSmartAccountConstant.defaultQueryOffset,
    this.limit = AuraSmartAccountConstant.defaultQueryLimit,
    this.orderBy = AuraSmartAccountOrder.ORDER_BY_ASC,
  });

  tx.OrderBy get getOrderBy {
    switch (orderBy) {
      case AuraSmartAccountOrder.ORDER_BY_ASC:
        return tx.OrderBy.ORDER_BY_ASC;
      case AuraSmartAccountOrder.ORDER_BY_DESC:
        return tx.OrderBy.ORDER_BY_DESC;
      case AuraSmartAccountOrder.ORDER_BY_UNSPECIFIED:
        return tx.OrderBy.ORDER_BY_UNSPECIFIED;
    }
  }
}
