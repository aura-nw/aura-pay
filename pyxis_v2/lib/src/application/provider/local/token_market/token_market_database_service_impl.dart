import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'token_market_db.dart';

final class TokenMarketDatabaseServiceImpl
    implements TokenMarketDatabaseService {
  final Isar _database;

  const TokenMarketDatabaseServiceImpl(this._database);

  @override
  Future<TokenMarketDto> add<P>(P param) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    return _database.writeTxn(
      () async {
        await _database.tokenMarketDbs.delete(id);
      },
    );
  }

  @override
  Future<void> deleteAll() {
    return _database.writeTxn(
      () async {
        await _database.tokenMarketDbs.where().deleteAll();
      },
    );
  }

  @override
  Future<TokenMarketDto?> get(int id) {
    return _database.tokenMarketDbs.get(id);
  }

  @override
  Future<List<TokenMarketDto>> getAll() {
    return _database.tokenMarketDbs.where().findAll();
  }

  @override
  Future<void> putAll({
    required List<PutAllTokenMarketRequestDto> param,
  }) {
    List<TokenMarketDb> tokenMarketsDb = param
        .map(
          (e) => e.mapRequestToDb,
        )
        .toList();

    return _database.writeTxn(
      () async {
        await _database.tokenMarketDbs.putAll(tokenMarketsDb);
      },
    );
  }

  @override
  Future<TokenMarketDto> update<P>(P param) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
