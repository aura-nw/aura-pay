import 'package:domain/domain.dart';

extension UpdateBalanceRequestMapper on UpdateBalanceRequest {
  UpdateBalanceRequestDto get mapRequest => UpdateBalanceRequestDto(
        tokenId: tokenId,
        balance: balance,
        type: type,
        symbol: symbol,
        name: name,
        decimal: decimal,
      );
}

extension UpdateAccountBalanceRequestMapper on UpdateAccountBalanceRequest {
  UpdateAccountBalanceRequestDto get mapRequest =>
      UpdateAccountBalanceRequestDto(
        balances: balances
            ?.map(
              (e) => e.mapRequest,
            )
            .toList(),
        id: id,
      );
}

final class UpdateAccountBalanceRequestDto {
  final int id;
  final List<UpdateBalanceRequestDto>? balances;

  const UpdateAccountBalanceRequestDto({
    required this.id,
    this.balances,
  });
}

final class UpdateBalanceRequestDto {
  final String balance;
  final int? tokenId;
  final String type;
  final String? name;
  final int? decimal;
  final String? symbol;

  const UpdateBalanceRequestDto({
    required this.balance,
    this.tokenId,
    required this.type,
    this.name,
    this.decimal,
    this.symbol,
  });
}
