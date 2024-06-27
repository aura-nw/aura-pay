import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'browser_db.dart';

final class BrowserDatabaseServiceImpl implements BrowserDatabaseService {
  final Isar _isar;

  const BrowserDatabaseServiceImpl(this._isar);

  @override
  Future<BrowserDto> add({
    required Map<String, dynamic> parameter,
  }) async {
    final BrowserDb browserDb = BrowserDb.fromAddJson(parameter);

    final browsers =
        await _isar.browserDbs.filter().browserIsActiveEqualTo(true).findAll();

    int id = browserDb.id;

    await _isar.writeTxn(() async {
      await _isar.browserDbs.putAll(
        browsers.map((e) => e.copyWithActive(false)).toList(),
      );
      id = await _isar.browserDbs.put(browserDb);
    });

    return browserDb.copyWithId(id);
  }

  @override
  Future<void> clear() async {
    await _isar.writeTxn(() async {
      await _isar.browserDbs.where().deleteAll();
    });
  }

  @override
  Future<void> delete({required int id}) async {
    await _isar.writeTxn(() async {
      await _isar.browserDbs.delete(id);
    });
  }

  @override
  Future<List<BrowserDto>> getAll() {
    return _isar.browserDbs.where().sortByBrowserIsActiveDesc().findAll();
  }

  @override
  Future<BrowserDto> update({
    required int id,
    required Map<String, dynamic> json,
  }) async {
    final BrowserDb browserDb = BrowserDb.fromJson(json);

    final List<BrowserDb> browserDbs = List.empty(growable: true);

    if (browserDb.isActive) {
      final browsers = await _isar.browserDbs
          .filter()
          .browserIsActiveEqualTo(true)
          .findAll();

      browserDbs.addAll(
        browsers.where((br) => br.id != id).toList(),
      );
    }

    final updateBrowser = browserDb.copyWithId(
      id,
    );

    await _isar.writeTxn(
      () async {
        await _isar.browserDbs.putAll(
          browserDbs.map((e) => e.copyWithActive(false)).toList(),
        );
        await _isar.browserDbs.put(
          updateBrowser,
        );
      },
    );

    return updateBrowser;
  }

  @override
  Future<BrowserDto?> getActiveBrowser() {
    return _isar.browserDbs.filter().browserIsActiveEqualTo(true).findFirst();
  }

  @override
  Future<BrowserDto?> getBrowserById(int id) {
    return _isar.browserDbs.get(id);
  }
}
