import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

part 'aura_account_db.g.dart';

extension AuraAccountDbExtension on AuraAccountDb {
  AuraAccountDb copyWith({
    AuraAccountType? type,
    String? address,
    String? name,
    int? id,
    int? index,
    AuraAccountRecoveryMethodDb? methodDb,
    bool ?needBackup,
  }) {
    return AuraAccountDb(
      accountId: id ?? this.id,
      accountType: type ?? this.type,
      accountAddress: address ?? this.address,
      accountName: name ?? this.name,
      methodDb: methodDb ?? this.methodDb,
      indexDb: index ?? this.index,
      needBackupDb: needBackup ?? needBackupDb,
    );
  }

  AuraAccountDb copyWithNull({
    AuraAccountType? type,
    String? address,
    String? name,
    int? id,
    int? index,
    AuraAccountRecoveryMethodDb? methodDb,
    bool ?needBackup,
  }) {
    return AuraAccountDb(
      accountId: id ?? this.id,
      accountType: type ?? this.type,
      accountAddress: address ?? this.address,
      accountName: name ?? this.name,
      methodDb: methodDb,
      indexDb: index ?? this.index,
      needBackupDb: needBackup ?? needBackupDb,
    );
  }
}

extension AuraAccountRecoveryMethodDbExtension on AuraAccountRecoveryMethodDb {
  AuraAccountRecoveryMethodDto get toDto => AuraAccountRecoveryMethodDto(
        method: method,
        value: value,
        subValue: subValue,
      );

  AuraAccountRecoveryMethodDb copyWith({
    AuraSmartAccountRecoveryMethod? method,
    String? value,
    String? subValue,
  }) =>
      AuraAccountRecoveryMethodDb(
        method: method ?? this.method,
        value: value ?? this.value,
        subValue: subValue ?? this.subValue,
      );
}

@Collection(
  inheritance: false,
)
class AuraAccountDb extends AuraAccountDto {
  final Id accountId;
  @enumerated
  final AuraAccountType accountType;
  final String accountAddress;
  final String accountName;
  final AuraAccountRecoveryMethodDb? methodDb;
  final int indexDb;
  final bool needBackupDb;

  AuraAccountDb({
    this.accountId = Isar.autoIncrement,
    required this.accountName,
    required this.accountAddress,
    required this.accountType,
    this.methodDb,
    this.indexDb = 1,
    this.needBackupDb = false,
  }) : super(
          id: accountId,
          name: accountName,
          address: accountAddress,
          type: accountType,
          method: methodDb?.toDto,
          index: indexDb,
          needBackup: needBackupDb,
        );
}

@embedded
final class AuraAccountRecoveryMethodDb {
  final String value;
  final String subValue;
  @enumerated
  final AuraSmartAccountRecoveryMethod method;

  const AuraAccountRecoveryMethodDb({
    this.method = AuraSmartAccountRecoveryMethod.web3Auth,
    this.value = '',
    this.subValue = '',
  });
}
