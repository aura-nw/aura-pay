import 'package:data/src/data/dto/browser_information_dto.dart';
import 'package:data/src/data/resource/local/browser_database_service.dart';
import 'package:domain/domain.dart';

final class BrowserManagementRepositoryImpl
    implements BrowserManagementRepository {
  final BrowserDataBaseService _browserDataBaseService;

  const BrowserManagementRepositoryImpl(this._browserDataBaseService);

  @override
  Future<void> addNewBookMark({
    required SaveBrowserParameter parameter,
  }) {
    return _browserDataBaseService.add(
      logo: parameter.logo,
      name: parameter.name,
      url: parameter.url,
      description: parameter.description,
    );
  }

  @override
  Future<void> deleteBookMark({
    required int id,
  }) {
    return _browserDataBaseService.delete(
      id: id,
    );
  }

  @override
  Future<List<BrowserInformation>> getBookmarks() async {
    final browsers = await _browserDataBaseService.getAll();

    return browsers
        .map(
          (e) => e.toEntity,
        )
        .toList();
  }

  @override
  Future<void> deleteAll() {
    return _browserDataBaseService.clear();
  }
}
