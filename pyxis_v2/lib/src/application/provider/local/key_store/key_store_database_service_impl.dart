import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'key_store_db.dart';

final class KeyStoreDatabaseServiceImpl implements KeyStoreDatabaseService {
  final Isar _database;

  const KeyStoreDatabaseServiceImpl(this._database);

  @override
  Future<KeyStoreDto> add<P>(P param) async {
    final AddKeyStoreRequestDto p = param as AddKeyStoreRequestDto;
    KeyStoreDb keyStoreDb = KeyStoreDb(
      keyName: p.keyName,
    );
    await _database.writeTxn(
      () async {
        final id = await _database.keyStoreDbs.put(keyStoreDb);

        keyStoreDb = keyStoreDb.copyWith(
          id: id,
        );
      },
    );

    return keyStoreDb;
  }

  @override
  Future<void> delete(int id) async {
    return _database.writeTxn(
      () async {
        await _database.keyStoreDbs.delete(id);
      },
    );
  }

  @override
  Future<KeyStoreDto?> get(int id) {
    return _database.keyStoreDbs.get(id);
  }

  @override
  Future<List<KeyStoreDto>> getAll() async {
    return _database.keyStoreDbs.where().findAll();
  }

  @override
  Future<KeyStoreDto> update<P>(P param) async {
    final UpdateKeyStoreRequestDto p = param as UpdateKeyStoreRequestDto;
    KeyStoreDb? keyStoreDb = await _database.keyStoreDbs.get(p.id);

    if (keyStoreDb != null) {
      keyStoreDb = keyStoreDb.copyWith(
        keyName: p.keyName,
      );

      await _database.writeTxn(
        () async {
          await _database.keyStoreDbs.put(
            keyStoreDb!,
          );
        },
      );

      return keyStoreDb;
    }

    throw Exception('Key store is not found');
  }

  @override
  Future<void> deleteAll() {
    return _database.writeTxn(() async{
      await _database.keyStoreDbs.where().deleteAll();
    },);
  }
}
