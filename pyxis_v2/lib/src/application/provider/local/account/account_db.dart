import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

part 'account_db.g.dart';


@Collection(inheritance: false)
final class AccountDb extends AccountDto {
  final Id aId;
  final String aName;
  final String aEvmAddress;
  final String ?aCosmosAddress;
  final int aKeyStoreId;
  @enumerated
  final AccountType aType;
  @enumerated
  final AccountCreateType aCreateType;

  AccountDb({
    this.aId = Isar.autoIncrement,
    required this.aName,
    required this.aEvmAddress,
    required this.aKeyStoreId,
    this.aCosmosAddress,
    this.aType = AccountType.normal,
    this.aCreateType = AccountCreateType.normal,
  }) : super(
    id: aId,
    name: aName,
    evmAddress: aEvmAddress,
    keyStoreId: aKeyStoreId,
    cosmosAddress: aCosmosAddress,
    type: aType,
    createType: aCreateType,
  );
}
