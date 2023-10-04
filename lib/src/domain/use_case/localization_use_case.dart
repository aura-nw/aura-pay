import 'package:pyxis_mobile/src/domain/repository/localization_repository.dart';

final class LocalizationUseCase {
  final LocalizationRepository _repository;

  const LocalizationUseCase(this._repository);

  Future<List<String>> getSupportLocale() async {
    return _repository.getSupportLocale();
  }

  Future<Map<String, dynamic>> getLocalLanguage({
    required String locale,
  }) async {
    return _repository.getLocalLanguage(
      locale: locale,
    );
  }

  Future<Map<String, String>> getRemoteLanguage({
    required String locale,
  }) async {
    return _repository.getRemoteLanguage(
      locale: locale,
    );
  }
}
