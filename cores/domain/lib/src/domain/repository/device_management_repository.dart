abstract interface class DeviceManagementRepository {
  Future<String> register({
    required Map<String, dynamic> body,
  });
}
