import 'package:domain/src/domain/entities/requests/query_token_market_parameter.dart';
import 'package:domain/src/domain/entities/token_market.dart';
import 'package:domain/src/domain/repository/token_repository.dart';

final class TokenUseCase {
  final TokenRepository _repository;

  const TokenUseCase(this._repository);

  Future<List<TokenMarket>> getAuraTokenPrice({
    bool onlyIbc = true,
  }) async {
    final QueryTokenMarketParameter parameter = QueryTokenMarketParameter(
      onlyIbc: onlyIbc,
    );
    return _repository.getAuraTokenPrice(
      queries: parameter.toJson(),
    );
  }
}
