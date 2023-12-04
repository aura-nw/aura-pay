import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  Future<String?> getValue(String key) async {
    return _storage.read(key: key,);
  }

  Future<bool> constantValue(String key) async {
    return _storage.containsKey(
      key: key,
    );
  }

  Future<void> deleteValue(String key) async {
    return _storage.delete(key: key);
  }

  Future<void> saveValue(String key, String value) async {
    return _storage.write(
      key: key,
      value: value,
    );
  }

  Future<Map<String,dynamic>> readAll()async{
    return _storage.readAll();
  }
}
