import 'package:domain/domain.dart';

extension BalanceDtoMapper on BalanceDto {
  Balance get toEntity => Balance(
        balance: balance,
        tokenId: tokenId,
        type: type,
      );
}

extension AccountBalanceDtoMapper on AccountBalanceDto {
  AccountBalance get toEntity => AccountBalance(
        id: id,
        accountId: accountId,
        balances: balances
            .map(
              (e) => e.toEntity,
            )
            .toList(),
      );
}

class AccountBalanceDto {
  final int id;
  final int accountId;
  final List<BalanceDto> balances;

  const AccountBalanceDto({
    required this.id,
    required this.accountId,
    required this.balances,
  });
}

class BalanceDto {
  final String balance;
  final int tokenId;
  final String type;

  const BalanceDto({
    required this.balance,
    required this.tokenId,
    required this.type,
  });
}
