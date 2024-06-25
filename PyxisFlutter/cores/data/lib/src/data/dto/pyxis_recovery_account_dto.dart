import 'package:domain/domain.dart';

extension PyxisRecoveryAccountDtoMapper on PyxisRecoveryAccountDto {
  PyxisRecoveryAccount get toEntity => PyxisRecoveryAccount(
        id: id,
        smartAccountAddress: smartAccountAddress,
        name: name,
      );
}

final class PyxisRecoveryAccountDto {
  final int id;
  final String? name;
  final String smartAccountAddress;

  const PyxisRecoveryAccountDto({
    required this.id,
    required this.smartAccountAddress,
    this.name,
  });

  factory PyxisRecoveryAccountDto.fromJson(Map<String, dynamic> json) {
    return PyxisRecoveryAccountDto(
      id: json['id'],
      smartAccountAddress: json['wallet_address'],
      name: json['name'],
    );
  }
}
