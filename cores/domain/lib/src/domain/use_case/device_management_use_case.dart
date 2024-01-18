import 'package:domain/src/domain/entities/requests/register_device_parameter.dart';
import 'package:domain/src/domain/repository/device_management_repository.dart';

final class DeviceManagementUseCase {
  final DeviceManagementRepository _repository;

  const DeviceManagementUseCase(this._repository);

  Future<String> registerDevice({
    required String pubKey,
    required String deviceId,
    required String unixTimestamp,
    required String signature,
  }) {
    final RegisterDeviceParameter parameter = RegisterDeviceParameter(
      pubKey: pubKey,
      deviceId: deviceId,
      data: unixTimestamp,
      signature: signature,
    );
    return _repository.register(
      body: parameter.toJson(),
    );
  }
}
