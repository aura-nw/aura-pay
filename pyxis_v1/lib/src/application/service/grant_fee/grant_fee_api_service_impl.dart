import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'grant_fee_api_service_impl.g.dart';

final class GrantFeeApiServiceImpl implements GrantFeeApiService {
  final GrantFeeApiServiceGenerate _apiServiceGenerate;

  const GrantFeeApiServiceImpl(this._apiServiceGenerate);

  @override
  Future<PyxisBaseResponse> grantFee({
    required Map<String, dynamic> body,
    required String accessToken,
  }) {
    return _apiServiceGenerate.grantFee(
      body,
      accessToken,
    );
  }
}

@RestApi()
abstract class GrantFeeApiServiceGenerate {
  factory GrantFeeApiServiceGenerate(
    Dio dio, {
    String? baseUrl,
  }) = _GrantFeeApiServiceGenerate;

  @POST(ApiServicePath.grantFee)
  Future<PyxisBaseResponse> grantFee(
    @Body() Map<String, dynamic> body,
    @Header('Authorization') String accessToken,
  );
}
