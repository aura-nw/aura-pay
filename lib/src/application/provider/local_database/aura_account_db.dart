import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

part 'aura_account_db.g.dart';

extension AuraAccountDbExtension on AuraAccountDb{
  AuraAccountDb copyWith({
    AuraAccountType? type,
    String? address,
    String? name,
    int? id,
  }) {
    return AuraAccountDb(
      accountId: id ?? this.id,
      accountType: type ?? this.type,
      accountAddress: address ?? this.address,
      accountName: name ?? this.name,
    );
  }
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

  AuraAccountDb({
    this.accountId = Isar.autoIncrement,
    required this.accountName,
    required this.accountAddress,
    required this.accountType,
  }) : super(
          id: accountId,
          name: accountName,
          address: accountAddress,
          type: accountType,
        );
}
