import 'package:domain/domain.dart';

extension AccountDtoMapper on AccountDto {
  Account get toEntity => Account(
        id: id,
        name: name,
        evmAddress: evmAddress,
        keyStoreId: keyStoreId,
        cosmosAddress: cosmosAddress,
        createType: createType,
        type: type,
        controllerKeyType: controllerKeyType,
      );
}

class AccountDto {
  final int id;
  final String name;
  final String evmAddress;
  final String? cosmosAddress;
  final int keyStoreId;
  final AccountType type;
  final AccountCreateType createType;
  final ControllerKeyType controllerKeyType;

  const AccountDto({
    required this.id,
    required this.name,
    required this.evmAddress,
    this.cosmosAddress,
    required this.keyStoreId,
    this.type = AccountType.normal,
    this.createType = AccountCreateType.normal,
    this.controllerKeyType = ControllerKeyType.passPhrase,
  });
}
