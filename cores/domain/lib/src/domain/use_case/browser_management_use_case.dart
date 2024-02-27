import 'package:domain/src/domain/entities/browser.dart';
import 'package:domain/src/domain/entities/requests/save_browser_parameter.dart';
import 'package:domain/src/domain/entities/requests/update_browser_parameter.dart';
import 'package:domain/src/domain/repository/browser_management_repository.dart';

final class BrowserManagementUseCase {
  final BrowserManagementRepository _repository;

  const BrowserManagementUseCase(this._repository);

  Future<void> addNewBrowser({
    required String url,
    required String logo,
    required String siteName,
    required bool isActive,
  }) {
    final SaveBrowserParameter parameter = SaveBrowserParameter(
      logo: logo,
      isActive: isActive,
      url: url,
      siteName: siteName,
    );

    return _repository.addNewBrowser(
      json: parameter.toJson(),
    );
  }

  Future<void> deleteBrowser({
    required int id,
  }) {
    return _repository.deleteBrowser(
      id: id,
    );
  }

  Future<List<Browser>> getBrowsers() {
    return _repository.getBrowsers();
  }

  Future<void> deleteAll() {
    return _repository.deleteAll();
  }

  Future<void> update({
    required int id,
    required String url,
    required String logo,
    required String siteName,
    required bool isActive,
  }) async {
    final UpdateBrowserParameter parameter = UpdateBrowserParameter(
      isActive: isActive,
      url: url,
      logo: logo,
      siteName: siteName,
    );
    return _repository.update(
      id: id,
      json: parameter.toJson(),
    );
  }
}
