final class UpdateAccountBalanceRequest {
  final int id;
  final List<UpdateBalanceRequest>? balances;

  const UpdateAccountBalanceRequest({
    required this.id,
    this.balances,
  });
}

final class UpdateBalanceRequest {
  final String balance;
  final int tokenId;
  final String type;

  const UpdateBalanceRequest({
    required this.balance,
    required this.tokenId,
    required this.type,
  });
}
