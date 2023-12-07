import 'package:data/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageServiceImpl(
    this._storage,
  );

  @override
  Future<bool> constantValue(String key) {
    return _storage.containsKey(
      key: key,
    );
  }

  @override
  Future<void> deleteValue(String key) {
    return _storage.delete(
      key: key,
    );
  }

  @override
  Future<String?> getValue(String key) {
    return _storage.read(
      key: key,
    );
  }

  @override
  Future<Map<String, dynamic>> readAll() {
    return _storage.readAll();
  }

  @override
  Future<void> saveValue(String key, String value) {
    return _storage.write(
      key: key,
      value: value,
    );
  }
}
