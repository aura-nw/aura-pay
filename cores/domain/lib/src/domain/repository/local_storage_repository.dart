abstract interface class LocalStorageRepository<K,V> {
  Future<void> saveValue({
    required K key,
    required V value,
  });

  Future<bool> constantKey({
    required K key,
  });

  Future<V> getValue<T>({
    required K key,
  });

  Future<void> deleteValue({
    required K key,
  });
}
