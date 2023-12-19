import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/aura_account_db.dart';

final class AccountDatabaseServiceImpl implements AccountDatabaseService {
  final Isar _isar;

  const AccountDatabaseServiceImpl(
    this._isar,
  );

  @override
  Future<void> deleteAccount(int id) async {
    await _isar.writeTxn(
      () async {
        _isar.auraAccountDbs.delete(id);
      },
    );
  }

  @override
  Future<AuraAccountDto?> getAccount(int id) {
    return _isar.auraAccountDbs.get(id);
  }

  @override
  Future<List<AuraAccountDto>> getAuraAccounts() {
    return _isar.auraAccountDbs.where().findAll();
  }

  @override
  Future<AuraAccountDto?> getFirstAccount() {
    return _isar.auraAccountDbs.where().findFirst();
  }

  @override
  Future<void> saveAccount({
    required String address,
    required String accountName,
    required AuraAccountType type,
  }) async {
    await _isar.writeTxn(
      () async {
        final AuraAccountDb accountDb = AuraAccountDb(
          accountName: accountName,
          accountAddress: address,
          accountType: type,
        );
        await _isar.auraAccountDbs.put(
          accountDb,
        );
      },
    );
  }

  @override
  Future<void> updateAccount({
    required int id,
    String? accountName,
    String? address,
    AuraAccountType? type,
    AuraSmartAccountRecoveryMethod? method,
    String? value,
    bool useNullAble = false,
  }) async {
    final AuraAccountDb? account = await _isar.auraAccountDbs.get(id);

    if (account != null) {
      AuraAccountRecoveryMethodDb? methodDb = account.methodDb;

      if (method != null && value != null) {
        methodDb ??= const AuraAccountRecoveryMethodDb();
      }

      await _isar.writeTxn(
        () async {
          if (useNullAble) {
            await _isar.auraAccountDbs.put(account.copyWithNull(
              name: accountName,
              address: address,
              type: type,
              methodDb: null,
            ));
          } else {
            await _isar.auraAccountDbs.put(account.copyWith(
              name: accountName,
              address: address,
              type: type,
              methodDb: methodDb?.copyWith(
                method: method,
                value: value,
              ),
            ));
          }
        },
      );
    }
  }
}
