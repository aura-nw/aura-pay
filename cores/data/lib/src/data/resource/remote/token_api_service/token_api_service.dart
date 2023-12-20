import 'token_base_response.dart';

abstract interface class TokenApiService {
  Future<TokenBaseResponse> getTokenPrice({
    required Map<String, dynamic> queries,
    required Map<String, dynamic> Function(Map<String, dynamic>) mapper,
  });
}
