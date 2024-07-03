import 'package:domain/domain.dart';

extension AccountDtoMapper on AccountDto {
  AccountDto get toEntity => AccountDto(
        id: id,
        name: name,
        evmAddress: evmAddress,
        keyStoreId: keyStoreId,
        cosmosAddress: cosmosAddress,
        createType: createType,
        type: type,
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

  const AccountDto({
    required this.id,
    required this.name,
    required this.evmAddress,
    this.cosmosAddress,
    required this.keyStoreId,
    this.type = AccountType.normal,
    this.createType = AccountCreateType.normal,
  });
}
