import 'package:domain/domain.dart';

extension PyxisBalanceDtoMapper on PyxisBalanceDto {
  PyxisBalance get toEntity => PyxisBalance(
        denom: denom,
        amount: amount,
      );
}

final class PyxisBalanceDto {
  final String denom;
  final String amount;

  const PyxisBalanceDto({
    required this.denom,
    required this.amount,
  });

  factory PyxisBalanceDto.fromJson(Map<String, dynamic> json) {
    return PyxisBalanceDto(
      denom: json['denom'],
      amount: json['amount'],
    );
  }
}
