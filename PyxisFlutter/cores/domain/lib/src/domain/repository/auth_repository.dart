abstract interface class AuthRepository {
  Future<String> signIn({
    required Map<String, dynamic> body,
  });

  Future<String?> getAccessToken({
    required String key,
  });

  Future<void> saveAccessToken({
    required String key,
    required String accessToken,
  });

  Future<void> removeCurrentAccessToken({
    required String key,
  });
}
