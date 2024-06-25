import 'package:domain/domain.dart';

extension GrantFeeDtoMapper on GrantFeeDto {
  GrantFee get toEntity => GrantFee(
        granter: granter,
        id: id,
      );
}

final class GrantFeeDto {
  final String granter;
  final int id;

  const GrantFeeDto({
    required this.granter,
    required this.id,
  });

  factory GrantFeeDto.fromJson(Map<String, dynamic> json) {
    return GrantFeeDto(
      granter: json['granter'],
      id: json['id'],
    );
  }
}
