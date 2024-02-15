import 'package:data/src/data/dto/token_market_dto.dart';
import 'package:data/src/data/resource/remote/token_api_service.dart';
import 'package:domain/domain.dart';

final class TokenRepositoryImpl implements TokenRepository {
  final TokenApiService _tokenApiService;

  const TokenRepositoryImpl(this._tokenApiService);

  @override
  Future<List<TokenMarket>> getAuraTokenPrice({
    required Map<String, dynamic> queries,
  }) async {
    final response = await _tokenApiService.getAuraTokenPrice(
      queries: queries,
    );

    final List<TokenMarketDto> tokenMarkets = List.empty(growable: true);

    for(final json in response){
      final TokenMarketDto tokenMarketDto = TokenMarketDto.fromJson(json);

      tokenMarkets.add(tokenMarketDto);
    }

    return tokenMarkets.map((e) => e.toEntity).toList();
  }
}
