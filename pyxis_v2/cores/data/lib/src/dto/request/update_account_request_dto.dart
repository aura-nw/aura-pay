import 'package:domain/domain.dart';

extension UpdateAccountRequestMapper on UpdateAccountRequest {
  UpdateAccountRequestDto get mapRequest => UpdateAccountRequestDto(
        cosmosAddress: cosmosAddress,
        type: type,
        createType: createType,
        keyStoreId: keyStoreId,
        evmAddress: evmAddress,
        name: name,
        id: id,
      );
}

final class UpdateAccountRequestDto {
  final String? name;
  final String? evmAddress;
  final String? cosmosAddress;
  final int? keyStoreId;
  final AccountType? type;
  final AccountCreateType? createType;
  final int id;

  const UpdateAccountRequestDto({
    this.name,
    this.createType,
    this.type,
    this.keyStoreId,
    this.evmAddress,
    this.cosmosAddress,
    required this.id,
  });
}
