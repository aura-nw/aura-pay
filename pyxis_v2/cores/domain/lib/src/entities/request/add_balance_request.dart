
final class AddAccountBalanceRequest {
  final int accountId;
  final List<AddBalanceRequest> balances;

  const AddAccountBalanceRequest({
    required this.accountId,
    required this.balances,
  });
}

final class AddBalanceRequest {
  final String balance;
  final int ?tokenId;
  final String type;
  final String? name;
  final int? decimal;
  final String? symbol;

  const AddBalanceRequest({
    required this.balance,
    this.tokenId,
    required this.type,
    this.name,
    this.decimal,
    this.symbol,
  });
}
