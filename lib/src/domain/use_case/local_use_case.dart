import 'package:pyxis_mobile/src/domain/repository/local_repository.dart';

class LocalUseCase {
  final LocalRepository _repository;

  const LocalUseCase(this._repository);

  Future<void> saveValue({
    required String value,
    required String key,
  }) async {
    return _repository.saveValue(key: key, value: value);
  }

  Future<bool> constantKey({required String key})async{
    return _repository.constantKey(key: key);
  }

  Future<String?> getValue({required String key})async{
    return _repository.getValue(key: key);
  }

}
