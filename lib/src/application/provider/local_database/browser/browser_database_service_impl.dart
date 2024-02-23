import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/browser/browser_db.dart';

final class BrowserDatabaseServiceImpl implements BrowserDatabaseService {
  final Isar _isar;

  const BrowserDatabaseServiceImpl(this._isar);

  @override
  Future<void> add({
    required Map<String, dynamic> parameter,
  }) async{
    final BrowserDb browserDb = BrowserDb.fromJson(parameter);

    await _isar.writeTxn(() async{
      await _isar.browserDbs.put(browserDb);
    });
  }

  @override
  Future<void> clear() async{
    await _isar.browserDbs.where().deleteAll();
  }

  @override
  Future<void> delete({required int id}) async{
    await _isar.writeTxn(() async{
      await _isar.browserDbs.delete(id);
    });
  }

  @override
  Future<List<BrowserDto>> getAll() {
    return _isar.browserDbs.where().findAll();
  }
}
