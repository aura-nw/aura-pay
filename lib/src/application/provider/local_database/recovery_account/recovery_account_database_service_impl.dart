import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'local_recovery_account_db.dart';

final class RecoveryAccountDatabaseServiceImpl
    implements RecoveryAccountDatabaseService {
  final Isar _isar;

  const RecoveryAccountDatabaseServiceImpl(this._isar);

  @override
  Future<void> deleteAccount(int id) async {
    await _isar.writeTxn(
      () async {
        await _isar.localRecoveryAccountDbs.delete(id);
      },
    );
  }

  @override
  Future<List<LocalRecoveryAccountDto>> getAuraAccounts() {
    return _isar.localRecoveryAccountDbs.where().findAll();
  }

  @override
  Future<void> saveRecoveryAccount({
    required String recoveryAddress,
    required String smartAccountAddress,
    required String name,
  }) async {
    await _isar.writeTxn(
      () async {
        await _isar.localRecoveryAccountDbs.put(
          LocalRecoveryAccountDb(
            recoveryAddressDb: recoveryAddress,
            nameDb: name,
            smartAccountAddressDb: smartAccountAddress,
          ),
        );
      },
    );
  }
}
