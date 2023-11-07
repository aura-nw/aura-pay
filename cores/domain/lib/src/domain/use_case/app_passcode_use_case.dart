import 'package:domain/src/domain/repository/local_security_storage_repository.dart';

class AppPassCodeUseCase {
  final LocalSecurityStorageRepository _repository;

  const AppPassCodeUseCase(this._repository);

  Future<void> savePassCode(
    String key,
    String passCode,
  ) async {
    return _repository.saveValue(
      key: key,
      value: passCode,
    );
  }

  Future<void> deletePassCode(String key) async {
    return _repository.deleteValue(key: key);
  }

  Future<String?> getCurrentPassCode(String key) async {
    return _repository.getValue(key: key);
  }

  Future<bool> comparePassCode(String key,String passCodeCompare)async{
    final String ? passCode = await getCurrentPassCode(key);

    return passCodeCompare == passCode;
  }
}
