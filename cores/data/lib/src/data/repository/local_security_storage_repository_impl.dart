import 'package:data/src/data/resource/local/secure_storage_service.dart';
import 'package:domain/domain.dart';

final class LocalSecurityRepositoryImpl
    implements LocalSecurityStorageRepository {
  final SecureStorageService _service;

  const LocalSecurityRepositoryImpl(this._service);

  @override
  Future<bool> constantKey({required String key}) {
    return _service.constantValue(key);
  }

  @override
  Future<void> deleteValue({required String key}) {
    return _service.deleteValue(key);
  }

  @override
  Future<String?> getValue<T>({required String key}) {
    return _service.getValue(key);
  }

  @override
  Future<void> saveValue({required String key, required String value}) {
    return _service.saveValue(key, value);
  }
}
