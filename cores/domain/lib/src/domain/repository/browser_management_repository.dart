import 'package:domain/src/domain/entities/browser.dart';

abstract interface class BrowserManagementRepository {
  Future<Browser> addNewBrowser({
    required Map<String, dynamic> json,
  });

  Future<void> update({
    required int id,
    required Map<String, dynamic> json,
  });

  Future<void> deleteBrowser({
    required int id,
  });

  Future<void> deleteAll();

  Future<List<Browser>> getBrowsers();

  Future<Browser?> getBrowserById(int id);

  Future<Browser?> getActiveBrowser();
}
