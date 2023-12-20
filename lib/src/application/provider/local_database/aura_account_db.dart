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
    AuraAccountRecoveryMethodDb? methodDb,
  }) {
    return AuraAccountDb(
      accountId: id ?? this.id,
      accountType: type ?? this.type,
      accountAddress: address ?? this.address,
      accountName: name ?? this.name,
      methodDb: methodDb ?? this.methodDb,
    );
  }

  AuraAccountDb copyWithNull({
    AuraAccountType? type,
    String? address,
    String? name,
    int? id,
    AuraAccountRecoveryMethodDb? methodDb,
  }) {
    return AuraAccountDb(
      accountId: id ?? this.id,
      accountType: type ?? this.type,
      accountAddress: address ?? this.address,
      accountName: name ?? this.name,
      methodDb: methodDb,
    );
  }
}

extension AuraAccountRecoveryMethodDbExtension on AuraAccountRecoveryMethodDb {
  AuraAccountRecoveryMethodDto get toDto => AuraAccountRecoveryMethodDto(
        method: method,
        value: value,
      );

  AuraAccountRecoveryMethodDb copyWith({
    AuraSmartAccountRecoveryMethod? method,
    String? value,
  }) =>
      AuraAccountRecoveryMethodDb(
        method: method ?? this.method,
        value: value ?? this.value,
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

  AuraAccountDb({
    this.accountId = Isar.autoIncrement,
    required this.accountName,
    required this.accountAddress,
    required this.accountType,
    this.methodDb,
  }) : super(
          id: accountId,
          name: accountName,
          address: accountAddress,
          type: accountType,
          method: methodDb?.toDto,
        );
}

@embedded
final class AuraAccountRecoveryMethodDb {
  final String value;
  @enumerated
  final AuraSmartAccountRecoveryMethod method;

  const AuraAccountRecoveryMethodDb({
    this.method = AuraSmartAccountRecoveryMethod.web3Auth,
    this.value = '',
  });
}
