import 'package:domain/src/domain/entities/browser_information.dart';
import 'package:domain/src/domain/entities/requests/save_browser_parameter.dart';

abstract interface class BrowserManagementRepository {
  Future<void> addNewBookMark({
    required SaveBrowserParameter parameter,
  });

  Future<void> deleteBookMark({
    required int id,
  });

  Future<void> deleteAll();

  Future<List<BrowserInformation>> getBookmarks();
}
