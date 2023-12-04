import 'package:domain/src/domain/repository/app_secure_repository.dart';

final class AppSecureUseCase {
  final AppSecureRepository _repository;

  const AppSecureUseCase(this._repository);

  Future<bool> hasPassCode({required String key,}){
    return _repository.hasPassCode(key: key);
  }

  Future<String?> getCurrentPassword({
    required String key,
  }) async {
    return _repository.getCurrentPassword(key: key);
  }

  Future<void> savePassword({required String key, required String password}) {
    return _repository.savePassword(
      key: key,
      passWord: password,
    );
  }
}
