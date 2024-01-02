import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'token_api_service_impl.g.dart';

class TokenApiServiceImpl implements TokenApiService {
  final TokenApiServiceGenerator _apiServiceGenerator;

  const TokenApiServiceImpl(
    this._apiServiceGenerator,
  );

  @override
  Future<AuraBaseResponseV1> getAuraTokenPrice() {
    return _apiServiceGenerator.getAuraTokenPrice();
  }

}

@RestApi()
abstract class TokenApiServiceGenerator {
  factory TokenApiServiceGenerator(
    Dio dio, {
    String? baseUrl,
  }) = _TokenApiServiceGenerator;

  @GET(ApiServicePath.auraPrice)
  Future<AuraBaseResponseV1> getAuraTokenPrice();
}
