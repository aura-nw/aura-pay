import 'package:data/data.dart';
import 'package:isar/isar.dart';

import 'account_db.dart';

final class AccountDatabaseServiceImpl implements AccountDatabaseService {
  final IsarCollection<AccountDb> _accountCollection;

  const AccountDatabaseServiceImpl(this._accountCollection);

  @override
  Future<AccountDto> add(AccountDto param) async {
    final AccountDb accountDb = AccountDb(
      aName: param.name,
      aEvmAddress: param.evmAddress,
      aKeyStoreId: param.keyStoreId,
      aCosmosAddress: param.cosmosAddress,
      aCreateType: param.createType,
      aType: param.type,
    );

    final int id = await _accountCollection.put(
      accountDb,
    );

    return accountDb;
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<AccountDto?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<AccountDto>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<AccountDto>> queryByAddress({required String address}) {
    // TODO: implement queryByAddress
    throw UnimplementedError();
  }

  @override
  Future<AccountDto> update(AccountDto param) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
