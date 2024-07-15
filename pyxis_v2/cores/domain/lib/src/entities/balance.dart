final class AccountBalance {
  final int id;
  final int accountId;
  final Balance cosmosBalance;
  final Balance evmBalance;

  const AccountBalance({
    required this.id,
    required this.accountId,
    required this.cosmosBalance,
    required this.evmBalance,
  });
}

abstract class Balance {
  final String balance;
  final int tokenId;

  const Balance({
    required this.balance,
    required this.tokenId,
  });
}

final class CosmosBalance extends Balance {
  const CosmosBalance({
    required super.balance,
    required super.tokenId,
  });
}

final class EvmBalance extends Balance {
  const EvmBalance({
    required super.balance,
    required super.tokenId,
  });
}
