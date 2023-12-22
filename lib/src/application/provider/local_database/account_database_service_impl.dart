import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';
import 'aura_account_db.dart';

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
    return _isar.auraAccountDbs.where().sortByIndexDb().findAll();
  }

  @override
  Future<AuraAccountDto?> getFirstAccount() {
    return _isar.auraAccountDbs.filter().indexDbEqualTo(0).findFirst();
  }

  @override
  Future<void> saveAccount({
    required String address,
    required String accountName,
    required AuraAccountType type,
  }) async {
    int currentLength = await _isar.auraAccountDbs.count();

    await _isar.writeTxn(
      () async {
        final AuraAccountDb accountDb = AuraAccountDb(
          accountName: accountName,
          accountAddress: address,
          accountType: type,
          indexDb: currentLength != 0 ? 1 : 0,
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
    String? subValue,
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
            await _isar.auraAccountDbs.put(
              account.copyWith(
                name: accountName,
                address: address,
                type: type,
                methodDb: methodDb?.copyWith(
                  method: method,
                  value: value,
                  subValue: subValue,
                ),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Future<void> updateChangeIndex({
    required int id,
  }) async {
    AuraAccountDb? account = await _isar.auraAccountDbs.get(id);

    final AuraAccountDb? currentAccount =
        await _isar.auraAccountDbs.filter().indexDbEqualTo(0).findFirst();

    if (account == null || currentAccount == null) return;

    await _isar.writeTxn(() async {
      await _isar.auraAccountDbs.put(
        currentAccount.copyWith(
          index: 1,
        ),
      );
      await _isar.auraAccountDbs.put(
        account.copyWith(
          index: 0,
        ),
      );
    });
  }
}
