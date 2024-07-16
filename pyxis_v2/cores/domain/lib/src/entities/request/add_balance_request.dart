final class AddAccountBalanceRequest {
  final int accountId;
  final AddBalanceRequest cosmosBalance;
  final AddBalanceRequest evmBalance;

  const AddAccountBalanceRequest({
    required this.accountId,
    required this.cosmosBalance,
    required this.evmBalance,
  });
}

final class AddBalanceRequest {
  final String balance;
  final int tokenId;

  const AddBalanceRequest({
    required this.balance,
    required this.tokenId,
  });
}
