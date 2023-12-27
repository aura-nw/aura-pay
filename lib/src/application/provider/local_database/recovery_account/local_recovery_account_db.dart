import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'local_recovery_account_db.g.dart';

@Collection(
  inheritance: false,
)
final class LocalRecoveryAccountDb extends LocalRecoveryAccountDto {
  final Id isarId;
  final String recoveryAddressDb;
  final String smartAccountAddressDb;
  final String nameDb;

  const LocalRecoveryAccountDb({
    this.isarId = Isar.autoIncrement,
    required this.recoveryAddressDb,
    required this.nameDb,
    required this.smartAccountAddressDb,
  }) : super(
          id: isarId,
          recoveryAddress: recoveryAddressDb,
          smartAccountAddress: smartAccountAddressDb,
          name: nameDb,
        );
}
