abstract interface class ControllerKeyRepository {
  Future<void> saveKey({
    required String address,
    required String key,
  });

  Future<bool> containAddress({
    required String address,
  });

  Future<String?> getKey({
    required String address,
  });

  Future<void> deleteKey({
    required String address,
  });
}
