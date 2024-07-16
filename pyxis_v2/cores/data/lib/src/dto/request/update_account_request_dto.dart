import 'package:domain/domain.dart';

extension UpdateAccountRequestMapper on UpdateAccountRequest {
  UpdateAccountRequestDto get mapRequest => UpdateAccountRequestDto(
        cosmosAddress: cosmosAddress,
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
  final int ?index;
  final int id;

  const UpdateAccountRequestDto({
    this.index,
    this.name,
    this.keyStoreId,
    this.evmAddress,
    this.cosmosAddress,
    required this.id,
  });
}
