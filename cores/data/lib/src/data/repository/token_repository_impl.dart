import 'package:data/src/data/resource/remote/api_service.dart';
import 'package:domain/domain.dart';

final class TokenRepositoryImpl implements TokenRepository {
  final TokenApiService _tokenApiService;

  const TokenRepositoryImpl(
    this._tokenApiService,
  );

  @override
  Future<double> getTokenPrice({
    required String id,
    required String currency,
  }) async {
    final response = await _tokenApiService.getTokenPrice(
      queries: {
        'ids': id,
        'vs_currencies': currency,
      },
      mapper: (json) {
        return json[id];
      },
    );

    return response.data[currency] ?? '';
  }
}
