import 'package:pyxis_mobile/src/domain/repository/local_storage_repository.dart';

class LocalSecurityStorageUseCase {
  final LocalStorageRepository _repository;

  const LocalSecurityStorageUseCase(this._repository);

  Future<void> saveValue({
    required String value,
    required String key,
  }) async {
    return _repository.saveValue<String>(key: key, value: value);
  }

  Future<bool> constantKey({required String key})async{
    return _repository.constantKey(key: key);
  }

  Future<String?> getValue({required String key})async{
    return _repository.getValue<String>(key: key);
  }

}
