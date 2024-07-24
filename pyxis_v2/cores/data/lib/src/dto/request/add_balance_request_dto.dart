import 'package:domain/domain.dart';

extension AddAccountBalanceRequestMapper on AddAccountBalanceRequest {
  AddAccountBalanceRequestDto get mapRequest => AddAccountBalanceRequestDto(
        accountId: accountId,
        balances: balances
            .map(
              (e) => e.mapRequest,
            )
            .toList(),
      );
}

extension AddBalanceRequestMapper on AddBalanceRequest {
  AddBalanceRequestDto get mapRequest => AddBalanceRequestDto(
        balance: balance,
        tokenId: tokenId,
        type: type,
        decimal: decimal,
        name: name,
        symbol: symbol,
      );
}

final class AddAccountBalanceRequestDto {
  final int accountId;
  final List<AddBalanceRequestDto> balances;

  const AddAccountBalanceRequestDto({
    required this.accountId,
    required this.balances,
  });
}

final class AddBalanceRequestDto {
  final String balance;
  final int? tokenId;
  final String type;
  final String? name;
  final int? decimal;
  final String? symbol;

  const AddBalanceRequestDto({
    required this.balance,
    this.tokenId,
    required this.type,
    this.name,
    this.decimal,
    this.symbol,
  });
}
