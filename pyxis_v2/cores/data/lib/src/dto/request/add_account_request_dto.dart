import 'package:domain/domain.dart';

extension AddAccountRequestMapper on AddAccountRequest {
  AddAccountRequestDto get mapRequest => AddAccountRequestDto(
        name: name,
        evmAddress: evmAddress,
        keyStoreId: keyStoreId,
        createType: createType,
        type: type,
        cosmosAddress: cosmosAddress,
        controllerKeyType: controllerKeyType,
      );
}

final class AddAccountRequestDto {
  final String name;
  final String evmAddress;
  final String? cosmosAddress;
  final int keyStoreId;
  final AccountType type;
  final AccountCreateType createType;
  final ControllerKeyType controllerKeyType;

  const AddAccountRequestDto({
    required this.name,
    required this.evmAddress,
    this.cosmosAddress,
    required this.keyStoreId,
    this.type = AccountType.normal,
    this.createType = AccountCreateType.normal,
    this.controllerKeyType = ControllerKeyType.passPhrase,
  });
}
