abstract interface class TokenApiService {
  Future<dynamic> getTokenMarkets({required Map<String,dynamic> queries});
}
