abstract interface class TokenApiService {
  Future<dynamic> getAuraTokenPrice({required Map<String,dynamic> queries});
}
