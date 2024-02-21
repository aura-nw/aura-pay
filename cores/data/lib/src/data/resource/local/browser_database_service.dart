import 'package:data/src/data/dto/browser_information_dto.dart';

abstract interface class BrowserDataBaseService {
  Future<void> add({
    required String logo,
    required String name,
    String? description,
    required String url,
  });

  Future<void> delete({
    required int id,
  });

  Future<void> clear();

  Future<List<BrowserInformationDto>> getAll();
}
