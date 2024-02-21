import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/browser/browser_information_db.dart';

final class BrowserDatabaseServiceImpl implements BrowserDataBaseService {
  final Isar _isar;

  const BrowserDatabaseServiceImpl(this._isar);

  @override
  Future<void> add({
    required String logo,
    required String name,
    String? description,
    required String url,
  }) async {
    final BrowserInformationDb browser = BrowserInformationDb(
      browserName: name,
      browserLogo: logo,
      browserUrl: url,
      browserDescription: description,
    );

    await _isar.writeTxn(() async {
      await _isar.browserInformationDbs.put(browser);
    });
  }

  @override
  Future<void> clear() async{
    await _isar.browserInformationDbs.where().deleteAll();
  }

  @override
  Future<void> delete({
    required int id,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.browserInformationDbs.delete(id);
    });
  }

  @override
  Future<List<BrowserInformationDto>> getAll() {
    return _isar.browserInformationDbs.where().findAll();
  }
}
