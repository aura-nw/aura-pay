import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'balance_db.dart';

final class BalanceDatabaseServiceImpl implements BalanceDatabaseService {
  final Isar _database;

  const BalanceDatabaseServiceImpl(this._database);

  @override
  Future<AccountBalanceDto> add<P>(P param) async {
    AccountBalanceDb balanceDb =
        (param as AddAccountBalanceRequestDto).mapRequestToDb;
    await _database.writeTxn(
      () async {
        final int id = await _database.accountBalanceDbs.put(
          balanceDb,
        );

        balanceDb = balanceDb.copyWith(
          id: id,
        );
      },
    );

    return balanceDb;
  }

  @override
  Future<void> delete(int id) {
    return _database.writeTxn(
      () async {
        await _database.accountBalanceDbs.delete(id);
      },
    );
  }

  @override
  Future<void> deleteAll() {
    return _database.writeTxn(
      () async {
        await _database.accountBalanceDbs.where().deleteAll();
      },
    );
  }

  @override
  Future<AccountBalanceDto?> get(int id) {
    return _database.accountBalanceDbs.get(id);
  }

  @override
  Future<List<AccountBalanceDto>> getAll() {
    return _database.accountBalanceDbs.where().findAll();
  }

  @override
  Future<AccountBalanceDto> update<P>(P param) async {
    param as UpdateAccountBalanceRequestDto;

    AccountBalanceDb? accountBalanceDb =
        await _database.accountBalanceDbs.get(param.id);

    if (accountBalanceDb != null) {
      accountBalanceDb = accountBalanceDb.copyWith(
        balances: param.balances
            ?.map(
              (e) => e.mapRequestToDb,
            )
            .toList(),
      );

      await _database.writeTxn(
        () async {
          await _database.accountBalanceDbs.put(accountBalanceDb!);
        },
      );

      return accountBalanceDb;
    }

    throw Exception('Account balance is not found');
  }

  @override
  Future<AccountBalanceDto?> getByAccountID({required int accountId}) {
    return _database.accountBalanceDbs
        .filter()
        .aAccountIdEqualTo(accountId)
        .findFirst();
  }
}
