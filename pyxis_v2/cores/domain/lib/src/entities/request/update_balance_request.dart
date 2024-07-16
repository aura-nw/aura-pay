final class UpdateAccountBalanceRequest {
  final int id;
  final UpdateBalanceRequest cosmosBalance;
  final UpdateBalanceRequest evmBalance;

  const UpdateAccountBalanceRequest({
    required this.id,
    required this.cosmosBalance,
    required this.evmBalance,
  });
}

final class UpdateBalanceRequest {
  final String ? balance;
  final int ?tokenId;

  const UpdateBalanceRequest({
    this.balance,
    this.tokenId,
  });
}