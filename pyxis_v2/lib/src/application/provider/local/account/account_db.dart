import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

part 'account_db.g.dart';

extension AddAEvmInfoRequestDtoMapper on AddAEvmInfoRequestDto {
  AEvmInfoDb get mapRequestToDb => AEvmInfoDb(
        aAddress: address,
        aIsActive: isActive,
      );
}

extension AddACosmosInfoRequestDtoMapper on AddACosmosInfoRequestDto {
  ACosmosInfoDb get mapRequestToDb => ACosmosInfoDb(
        aAddress: address,
        aIsActive: isActive,
      );
}

extension AddAccountRequestDtoMapper on AddAccountRequestDto {
  AccountDb get mapRequestToDb => AccountDb(
        aIndex: index,
        aName: name,
        aEvmAddress: '',
        aKeyStoreId: keyStoreId,
        aCosmosInfoDb: addACosmosInfoRequest.mapRequestToDb,
        aEvmInfoDb: addAEvmInfoRequest.mapRequestToDb,
        aControllerKeyType: controllerKeyType,
        aType: type,
        aCosmosAddress: '',
        aCreateType: createType,
      );
}

extension UpdateAEvmInfoRequestDtoMapper on UpdateAEvmInfoRequestDto {
  AEvmInfoDb get mapRequestToDb => AEvmInfoDb(
    aAddress: address,
    aIsActive: isActive,
  );
}

extension UpdateACosmosInfoRequestDtoMapper on UpdateACosmosInfoRequestDto {
  ACosmosInfoDb get mapRequestToDb => ACosmosInfoDb(
    aAddress: address,
    aIsActive: isActive,
  );
}

extension AccountDbExtension on AccountDb {
  AccountDb copyWith({
    String? name,
    String? evmAddress,
    String? cosmosAddress,
    int? keyStoreId,
    int? id,
    int? index,
    AccountCreateType? createType,
    AccountType? type,
    ControllerKeyType? controllerKeyType,
    AEvmInfoDb? aEvmInfoDb,
    ACosmosInfoDb? aCosmosInfoDb,
  }) {
    return AccountDb(
      aName: name ?? aName,
      aEvmAddress: evmAddress ?? aEvmAddress,
      aKeyStoreId: keyStoreId ?? aKeyStoreId,
      aType: type ?? aType,
      aCreateType: createType ?? aCreateType,
      aCosmosAddress: cosmosAddress ?? aCosmosAddress,
      aId: id ?? aId,
      aControllerKeyType: controllerKeyType ?? aControllerKeyType,
      aIndex: index ?? aIndex,
      aEvmInfoDb: aEvmInfoDb ?? this.aEvmInfoDb,
      aCosmosInfoDb: aCosmosInfoDb ?? this.aCosmosInfoDb,
    );
  }
}

@Collection(inheritance: false)
final class AccountDb extends AccountDto {
  final Id aId;
  final int aIndex;
  final String aName;
  @Deprecated('Replace by AEvmInfoDto')
  final String aEvmAddress;
  @Deprecated('Replace by ACosmosInfoDto')
  final String? aCosmosAddress;
  final int aKeyStoreId;
  @enumerated
  final AccountType aType;
  @enumerated
  final AccountCreateType aCreateType;
  @enumerated
  final ControllerKeyType aControllerKeyType;

  final AEvmInfoDb aEvmInfoDb;
  final ACosmosInfoDb aCosmosInfoDb;

  AccountDb({
    this.aId = Isar.autoIncrement,
    required this.aIndex,
    required this.aName,
    required this.aEvmAddress,
    required this.aKeyStoreId,
    this.aCosmosAddress,
    this.aType = AccountType.normal,
    this.aCreateType = AccountCreateType.normal,
    this.aControllerKeyType = ControllerKeyType.passPhrase,
    required this.aCosmosInfoDb,
    required this.aEvmInfoDb,
  }) : super(
          id: aId,
          index: aIndex,
          name: aName,
          evmAddress: aEvmAddress,
          keyStoreId: aKeyStoreId,
          cosmosAddress: aCosmosAddress,
          type: aType,
          createType: aCreateType,
          controllerKeyType: aControllerKeyType,
          aEvmInfo: aEvmInfoDb,
          aCosmosInfo: aCosmosInfoDb,
        );
}

@embedded
class AEvmInfoDb extends AEvmInfoDto {
  final String aAddress;
  final bool aIsActive;

  const AEvmInfoDb({
    this.aAddress = '',
    this.aIsActive = false,
  }) : super(
          address: aAddress,
          isActive: aIsActive,
        );
}

@embedded
class ACosmosInfoDb extends ACosmosInfoDto {
  final String aAddress;
  final bool aIsActive;

  const ACosmosInfoDb({
    this.aAddress = '',
    this.aIsActive = false,
  }) : super(
          address: aAddress,
          isActive: aIsActive,
        );
}
