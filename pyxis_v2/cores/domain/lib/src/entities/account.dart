import 'package:domain/core/enum.dart';

final class Account {
  final int id;
  final String name;
  final String evmAddress;
  final String? cosmosAddress;
  final int keyStoreId;
  final AccountType type;
  final AccountCreateType createType;

  const Account({
    required this.id,
    required this.name,
    required this.evmAddress,
    this.cosmosAddress,
    required this.keyStoreId,
    this.type = AccountType.normal,
    this.createType = AccountCreateType.normal,
  });

  bool get isAbstractAccount => type == AccountType.abstraction;
}
