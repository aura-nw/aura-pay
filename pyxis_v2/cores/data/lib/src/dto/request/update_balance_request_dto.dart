import 'package:domain/domain.dart';

extension UpdateBalanceRequestMapper on UpdateBalanceRequest {
  UpdateBalanceRequestDto get mapRequest => UpdateBalanceRequestDto(
        tokenId: tokenId,
        balance: balance,
      );
}

extension UpdateAccountBalanceRequestMapper on UpdateAccountBalanceRequest {
  UpdateAccountBalanceRequestDto get mapRequest =>
      UpdateAccountBalanceRequestDto(
        evmBalance: evmBalance.mapRequest,
        cosmosBalance: cosmosBalance.mapRequest,
        id: id,
      );
}

final class UpdateAccountBalanceRequestDto {
  final int id;
  final UpdateBalanceRequestDto cosmosBalance;
  final UpdateBalanceRequestDto evmBalance;

  const UpdateAccountBalanceRequestDto({
    required this.id,
    required this.cosmosBalance,
    required this.evmBalance,
  });
}

final class UpdateBalanceRequestDto {
  final String? balance;
  final int? tokenId;

  const UpdateBalanceRequestDto({
    this.balance,
    this.tokenId,
  });
}
