import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'device_management_api_service_impl.g.dart';

final class DeviceManagementApiServiceImpl implements DeviceManagementApiService{
  final DeviceManagementApiServiceGenerate _apiServiceGenerate;

  const DeviceManagementApiServiceImpl(this._apiServiceGenerate);
  @override
  Future<PyxisBaseResponse> register({required Map<String, dynamic> body}) {
    return _apiServiceGenerate.register(body);
  }

}

@RestApi()
abstract class DeviceManagementApiServiceGenerate {
  factory DeviceManagementApiServiceGenerate(
    Dio dio, {
    String? baseUrl,
  }) = _DeviceManagementApiServiceGenerate;

  @POST(ApiServicePath.registerDevice)
  Future<PyxisBaseResponse> register(
    @Body() Map<String, dynamic> body,
  );
}
