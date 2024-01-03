import 'package:data/src/data/resource/remote/token_api_service.dart';
import 'package:domain/domain.dart';

final class TokenRepositoryImpl implements TokenRepository{
  final TokenApiService _tokenApiService;

  const TokenRepositoryImpl(this._tokenApiService);

  @override
  Future<double> getAuraTokenPrice() async {
    final response = await _tokenApiService.getAuraTokenPrice();

    return double.tryParse( response.data) ?? 0;
  }
}