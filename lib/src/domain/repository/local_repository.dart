abstract interface class LocalRepository {
  Future<void> saveValue({
    required String key,
    required String value,
  });

  Future<bool> constantKey({
    required String key,
  });

  Future<String?> getValue({
    required String key,
  });
}
