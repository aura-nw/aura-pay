import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'smart_account_api_service_impl.g.dart';

final class SmartAccountApiServiceImpl implements SmartAccountApiService {
  final SmartAccountApiServiceGenerate _apiServiceGenerate;

  const SmartAccountApiServiceImpl(this._apiServiceGenerate);
  @override
  Future<PyxisBaseResponse> getRecoveryAccountByAddress({
    required Map<String, dynamic> queries,
  }) {
    return _apiServiceGenerate.getRecoveryAccountByAddress(queries);
  }

  @override
  Future<PyxisBaseResponse> insertRecoveryAccount({
    required Map<String, dynamic> body,
  }) {
    return _apiServiceGenerate.insertRecoveryAccount(body);
  }
}

@RestApi()
abstract class SmartAccountApiServiceGenerate {
  factory SmartAccountApiServiceGenerate(
    Dio dio, {
    String? baseUrl,
  }) = _SmartAccountApiServiceGenerate;

  @GET(ApiServicePath.recoveryAccounts)
  Future<PyxisBaseResponse> getRecoveryAccountByAddress(
    @Queries() Map<String, dynamic> queries,
  );

  @POST(ApiServicePath.recoveryAccounts)
  Future<PyxisBaseResponse> insertRecoveryAccount(
    @Body() Map<String, dynamic> body,
  );
}
