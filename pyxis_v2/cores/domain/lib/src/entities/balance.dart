import 'package:domain/core/enum.dart';

final class AccountBalance {
  final int id;
  final int accountId;
  final List<Balance> balances;

  const AccountBalance({
    required this.id,
    required this.accountId,
    required this.balances,
  });
}

final class Balance {
  final String balance;
  final int tokenId;
  final String type;

  const Balance({
    required this.balance,
    required this.tokenId,
    required this.type,
  });

  AppNetworkType get networkType {
    switch (type) {
      case 'evm':
        return AppNetworkType.evm;
      case 'cosmos':
        return AppNetworkType.cosmos;
      default:
        return AppNetworkType.other;
    }
  }
}
