import 'package:data/data.dart';
import 'package:data/src/data/dto/browser_dto.dart';
import 'package:domain/domain.dart';

final class BrowserManagementRepositoryImpl
    implements BrowserManagementRepository {
  final LocalBrowserInterface _localBrowserInterface;

  const BrowserManagementRepositoryImpl(this._localBrowserInterface);

  @override
  Future<void> addNewBrowser({
    required Map<String, dynamic> json,
  }) {
    return (_localBrowserInterface as BrowserDatabaseService).add(
      parameter: json,
    );
  }

  @override
  Future<void> deleteAll() {
    return (_localBrowserInterface as BrowserDatabaseService).clear();
  }

  @override
  Future<void> deleteBrowser({
    required int id,
  }) {
    return _localBrowserInterface.delete(id: id);
  }

  @override
  Future<List<Browser>> getBrowsers() async {
    final browsers =
        await (_localBrowserInterface as BrowserDatabaseService).getAll();

    return browsers
        .map(
          (e) => e.toEntity,
        )
        .toList();
  }
}
