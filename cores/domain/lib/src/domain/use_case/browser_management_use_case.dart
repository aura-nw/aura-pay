import 'package:domain/src/domain/entities/browser.dart';
import 'package:domain/src/domain/entities/requests/save_bookmark_parameter.dart';
import 'package:domain/src/domain/repository/browser_management_repository.dart';

final class BrowserManagementUseCase {
  final BrowserManagementRepository _repository;

  const BrowserManagementUseCase(this._repository);

  Future<void> addNewBrowser({
    required String logo,
    required String name,
    String? description,
    required String url,
  }) {
    final SaveBookMarkParameter parameter = SaveBookMarkParameter(
      logo: logo,
      name: name,
      url: url,
      description: description,
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

  Future<void> deleteAll(){
    return _repository.deleteAll();
  }
}
