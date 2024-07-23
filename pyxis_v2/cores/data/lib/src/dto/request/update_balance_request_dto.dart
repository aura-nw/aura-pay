import 'package:domain/domain.dart';

extension UpdateBalanceRequestMapper on UpdateBalanceRequest {
  UpdateBalanceRequestDto get mapRequest => UpdateBalanceRequestDto(
        tokenId: tokenId,
        balance: balance,
        type: type,
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
  final int ?tokenId;
  final String type;

  const UpdateBalanceRequestDto({
    required this.balance,
    this.tokenId,
    required this.type,
  });
}
