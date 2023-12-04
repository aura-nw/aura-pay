abstract interface class AppSecureRepository {
  Future<void> savePassword({
    required String key,
    required String passWord,
  });

  Future<String?> getCurrentPassword({
    required String key,
  });

  Future<bool> hasPassCode({
    required String key,
  });
}
