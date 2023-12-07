abstract interface class SecureStorageService {
  Future<String?> getValue(String key);

  Future<bool> constantValue(String key);

  Future<void> deleteValue(String key);

  Future<void> saveValue(String key, String value);

  Future<Map<String,dynamic>> readAll();
}
