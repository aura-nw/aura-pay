import 'package:domain/domain.dart';

extension BalanceDtoMapper on BalanceDto {
  Balance get toCosmosBalance => Balance(
        balance: balance,
        tokenId: tokenId,
      );

  Balance get toEvmBalance => Balance(
        balance: balance,
        tokenId: tokenId,
      );
}

extension AccountBalanceDtoMapper on AccountBalanceDto {
  AccountBalance get toEntity => AccountBalance(
        id: id,
        accountId: accountId,
        cosmosBalance: cosmosBalance.toCosmosBalance,
        evmBalance: evmBalance.toEvmBalance,
      );
}

class AccountBalanceDto {
  final int id;
  final int accountId;
  final BalanceDto cosmosBalance;
  final BalanceDto evmBalance;

  const AccountBalanceDto({
    required this.id,
    required this.accountId,
    required this.cosmosBalance,
    required this.evmBalance,
  });
}

class BalanceDto {
  final String balance;
  final int tokenId;
  const BalanceDto({
    required this.balance,
    required this.tokenId,
  });
}
