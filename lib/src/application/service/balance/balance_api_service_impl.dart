import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'balance_api_service_impl.g.dart';

class BalanceApiServiceImpl implements BalanceApiService {
  final BalanceApiServiceGenerator _apiServiceGenerator;

  const BalanceApiServiceImpl(
    this._apiServiceGenerator,
  );

  @override
  Future<AuraBaseResponseV2> getBalances({required Map<String, dynamic> body}) {
    return _apiServiceGenerator.getBalances(body);
  }
}

@RestApi()
abstract class BalanceApiServiceGenerator {
  factory BalanceApiServiceGenerator(
    Dio dio, {
    String? baseUrl,
  }) = _BalanceApiServiceGenerator;

  @POST(ApiServicePath.graphiql)
  Future<AuraBaseResponseV2> getBalances(
    @Body() Map<String, dynamic> body,
  );
}
