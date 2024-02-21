import 'package:domain/src/domain/entities/browser_information.dart';
import 'package:domain/src/domain/entities/requests/save_browser_parameter.dart';
import 'package:domain/src/domain/repository/browser_management_repository.dart';

final class BrowserManagementUseCase {
  final BrowserManagementRepository _repository;

  const BrowserManagementUseCase(this._repository);

  Future<void> addNewBookMark({
    required String logo,
    required String name,
    String? description,
    required String url,
  }) {
    final SaveBrowserParameter parameter = SaveBrowserParameter(
      logo: logo,
      name: name,
      url: url,
      description: description,
    );

    return _repository.addNewBookMark(
      parameter: parameter,
    );
  }

  Future<void> deleteBookMark({
    required int id,
  }) {
    return _repository.deleteBookMark(
      id: id,
    );
  }

  Future<void> deleteAll() {
    return _repository.deleteAll();
  }

  Future<List<BrowserInformation>> getBookmarks() {
    return _repository.getBookmarks();
  }
}
