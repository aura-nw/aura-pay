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
  final int ?tokenId;
  final String type;
  final String? name;
  final int? decimal;
  final String? symbol;

  const UpdateBalanceRequest({
    required this.balance,
    this.tokenId,
    required this.type,
    this.name,
    this.decimal,
    this.symbol,
  });
}
