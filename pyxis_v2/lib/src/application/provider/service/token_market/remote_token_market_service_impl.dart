import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_v2/src/application/provider/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'remote_token_market_service_impl.g.dart';

final class RemoteTokenMarketServiceImpl implements RemoteTokenMarketService {

  final RemoteTokenMarketServiceGenerator _generator;

  const RemoteTokenMarketServiceImpl(this._generator);

  @override
  Future<dynamic> getRemoteTokenMarket() {
    return _generator.getRemoteTokenMarket();
  }
}

@RestApi()
abstract class RemoteTokenMarketServiceGenerator {
  factory RemoteTokenMarketServiceGenerator(
    Dio dio, {
    String? baseUrl,
  }) = _RemoteTokenMarketServiceGenerator;

  @GET(ApiServicePath.tokenMarket)
  Future<dynamic> getRemoteTokenMarket();
}
