import 'package:data/data.dart';
import 'package:isar/isar.dart';

import 'account_db.dart';

final class AccountDatabaseServiceImpl implements AccountDatabaseService {
  final Isar _database;

  const AccountDatabaseServiceImpl(this._database);

  @override
  Future<AccountDto> add<P>(P param) async {
    final AddAccountRequestDto p = param as AddAccountRequestDto;
    AccountDb accountDb = AccountDb(
      aName: p.name,
      aEvmAddress: p.evmAddress,
      aKeyStoreId: p.keyStoreId,
      aCosmosAddress: p.cosmosAddress,
      aCreateType: p.createType,
      aType: p.type,
      aControllerKeyType: p.controllerKeyType,
      aIndex: p.index,
    );

    await _database.writeTxn(
      () async {
        final id = await _database.accountDbs.put(accountDb);

        accountDb = accountDb.copyWith(
          id: id,
        );
      },
    );

    return accountDb;
  }

  @override
  Future<void> delete(int id) {
    return _database.writeTxn(
      () async {
        await _database.accountDbs.delete(id);
      },
    );
  }

  @override
  Future<AccountDto?> get(int id) {
    return _database.accountDbs.get(id);
  }

  @override
  Future<List<AccountDto>> getAll() {
    return _database.accountDbs.where().findAll();
  }

  @override
  Future<List<AccountDto>> queryByAddress({
    required String address,
  }) {
    // TODO: implement queryByAddress
    throw UnimplementedError();
  }

  @override
  Future<AccountDto> update<P>(P param) async {
    final UpdateAccountRequestDto p = param as UpdateAccountRequestDto;
    AccountDb? accountDb = await _database.accountDbs.get(
      p.id,
    );

    if (accountDb != null) {
      accountDb = accountDb.copyWith(
        name: p.name,
        evmAddress: p.evmAddress,
        cosmosAddress: p.cosmosAddress,
        keyStoreId: p.keyStoreId,
        index: p.index,
      );

      await _database.writeTxn(
        () async {
          await _database.accountDbs.put(accountDb!);
        },
      );

      return accountDb;
    }

    throw Exception('Account is not found');
  }

  @override
  Future<AccountDto?> getFirstAccount() {
    return _database.accountDbs.filter().aIndexEqualTo(0).findFirst();
  }

  @override
  Future<void> deleteAll() {
    return _database.writeTxn(() async{
      await _database.accountDbs.where().deleteAll();
    },);
  }

  @override
  Future<void> updateChangeIndex({
    required int id,
  }) async {
    AccountDb? account = await _database.accountDbs.get(id);

    final AccountDb? currentAccount =
    await _database.accountDbs.filter().aIndexEqualTo(0).findFirst();

    if (account == null || currentAccount == null) return;

    await _database.writeTxn(() async {
      await _database.accountDbs.put(
        currentAccount.copyWith(
          index: 1,
        ),
      );
      await _database.accountDbs.put(
        account.copyWith(
          index: 0,
        ),
      );
    });
  }
}
