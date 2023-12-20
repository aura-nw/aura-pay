abstract class TokenRepository {
  Future<double> getTokenPrice({
    required String id,
    required String currency,
  });
}
