import 'package:domain/domain.dart';

extension AddAccountBalanceRequestMapper on AddAccountBalanceRequest {
  AddAccountBalanceRequestDto get mapRequest => AddAccountBalanceRequestDto(
        accountId: accountId,
        cosmosBalance: cosmosBalance.mapRequest,
        evmBalance: evmBalance.mapRequest,
      );
}

extension AddBalanceRequestMapper on AddBalanceRequest {
  AddBalanceRequestDto get mapRequest => AddBalanceRequestDto(
        balance: balance,
        tokenId: tokenId,
      );
}

final class AddAccountBalanceRequestDto {
  final int accountId;
  final AddBalanceRequestDto cosmosBalance;
  final AddBalanceRequestDto evmBalance;

  const AddAccountBalanceRequestDto({
    required this.accountId,
    required this.cosmosBalance,
    required this.evmBalance,
  });
}

final class AddBalanceRequestDto {
  final String balance;
  final int tokenId;

  const AddBalanceRequestDto({
    required this.balance,
    required this.tokenId,
  });
}
