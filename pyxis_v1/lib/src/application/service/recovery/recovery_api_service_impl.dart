import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'recovery_api_service_impl.g.dart';

final class RecoveryApiServiceImpl implements RecoveryApiService {
  final RecoveryApiServiceGenerate _apiServiceGenerate;

  const RecoveryApiServiceImpl(this._apiServiceGenerate);

  @override
  Future<HasuraBaseResponse> getRecoveryAccountByAddress({
    required Map<String, dynamic> queries,
    required String accessToken,
  }) {
    return _apiServiceGenerate.getRecoveryAccountByAddress(
      queries,
      accessToken,
    );
  }
}

@RestApi()
abstract class RecoveryApiServiceGenerate {
  factory RecoveryApiServiceGenerate(
    Dio dio, {
    String? baseUrl,
  }) = _RecoveryApiServiceGenerate;

  @GET(ApiServicePath.recoveryAccounts)
  Future<HasuraBaseResponse> getRecoveryAccountByAddress(
    @Queries() Map<String, dynamic> queries,
    @Header('Authorization') String accessToken,
  );
}
