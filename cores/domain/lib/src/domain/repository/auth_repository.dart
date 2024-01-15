abstract interface class AuthRepository {
  Future<String> signIn({
    required Map<String, dynamic> body,
  });
}
