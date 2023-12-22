abstract interface class StorageService {
  Future<String?> getValue(String key);

  Future<bool> constantValue(String key);

  Future<void> deleteValue(String key);

  Future<void> saveValue(String key, String value);

  Future<Map<String, dynamic>> readAll();
}

// for secure service
abstract interface class SecureStorageService implements StorageService {}
// for normal service
abstract interface class NormalStorageService implements StorageService {}
