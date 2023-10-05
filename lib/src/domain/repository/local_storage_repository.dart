abstract interface class LocalStorageRepository {
  Future<void> saveValue<T>({
    required String key,
    required T value,
  });

  Future<bool> constantKey({
    required String key,
  });

  Future<T?> getValue<T>({
    required String key,
  });
}
