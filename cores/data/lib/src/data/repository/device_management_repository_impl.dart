import 'package:data/src/data/resource/remote/device_management_api_service.dart';
import 'package:domain/domain.dart';

final class DeviceManagementRepositoryImpl
    implements DeviceManagementRepository {
  final DeviceManagementApiService _deviceManagementApiService;

  const DeviceManagementRepositoryImpl(this._deviceManagementApiService);

  @override
  Future<String> register({
    required Map<String, dynamic> body,
  }) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
