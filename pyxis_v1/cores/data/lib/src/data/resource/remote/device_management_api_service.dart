import 'package:data/src/core/base_response.dart';

abstract interface class DeviceManagementApiService {
  Future<PyxisBaseResponse> register({
    required Map<String, dynamic> body,
  });
}
