import 'package:domain/core/enum.dart';

final class Account {
  final int id;

  // 0 -> active 1. normal
  final int index;
  final String name;
  final int keyStoreId;
  final AccountType type;
  final AccountCreateType createType;
  final ControllerKeyType controllerKeyType;
  final AEvmInfo aEvmInfo;
  final ACosmosInfo aCosmosInfo;

  const Account({
    required this.id,
    required this.index,
    required this.name,
    required this.keyStoreId,
    this.type = AccountType.normal,
    this.createType = AccountCreateType.normal,
    this.controllerKeyType = ControllerKeyType.passPhrase,
    required this.aCosmosInfo,
    required this.aEvmInfo,
  });

  @Deprecated('Replace by AEvmInfo')
  String get evmAddress => aEvmInfo.displayAddress;

  @Deprecated('Replace by ACosmosInfo')
  String? get cosmosAddress {
    final displayAddress = aCosmosInfo.displayAddress;
    return displayAddress.isEmpty ? null : displayAddress;
  }

  bool get isAbstractAccount => type == AccountType.abstraction;
}

final class AEvmInfo {
  final String address;
  final bool isActive;

  const AEvmInfo({
    required this.address,
    required this.isActive,
  });

  String get displayAddress{
    if(isActive){
      return address;
    }
    return '';
  }
}

final class ACosmosInfo {
  final String address;
  final bool isActive;

  const ACosmosInfo({
    required this.address,
    required this.isActive,
  });

  String get displayAddress{
    if(isActive){
      return address;
    }
    return '';
  }
}
