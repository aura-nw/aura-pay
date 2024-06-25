import 'package:domain/src/domain/entities/token_market.dart';

abstract interface class TokenRepository{
  Future<List<TokenMarket>> getTokenMarkets({required Map<String,dynamic> queries});
}