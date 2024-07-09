import 'package:data/data.dart';
import 'package:isar/isar.dart';

import 'account_db.dart';

final class AccountDatabaseServiceImpl implements AccountDatabaseService {
  final Isar _database;

  const AccountDatabaseServiceImpl(this._database);

  @override
  Future<AccountDto> add(AddAccountRequestDto param) async {
    AccountDb accountDb = AccountDb(
      aName: param.name,
      aEvmAddress: param.evmAddress,
      aKeyStoreId: param.keyStoreId,
      aCosmosAddress: param.cosmosAddress,
      aCreateType: param.createType,
      aType: param.type,
      aControllerKeyType: param.controllerKeyType,
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
  Future<AccountDto> update(UpdateAccountRequestDto param) async {
    AccountDb? accountDb = await _database.accountDbs.get(
      param.id,
    );

    if (accountDb != null) {
      accountDb = accountDb.copyWith(
        name: param.name,
        evmAddress: param.evmAddress,
        cosmosAddress: param.cosmosAddress,
        keyStoreId: param.keyStoreId,
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
    return _database.accountDbs.where().findFirst();
  }

  @override
  Future<void> deleteAll() {
    return _database.accountDbs.where().deleteAll();
  }
}
