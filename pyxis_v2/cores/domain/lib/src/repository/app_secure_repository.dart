abstract interface class AppSecureRepository {
  Future<void> savePassword({
    required String key,
    required String passWord,
  });

  Future<String?> getCurrentPassword({
    required String key,
  });

  Future<bool> hadPassCode({
    required String key,
  });

  Future<bool> canAuthenticateWithBiometrics();

  Future<bool> requestBiometric({
    String? localizedReason,
    String? androidSignTitle,
    String? cancelButton,
  });

  Future<void> setEnableBiometric({
    required String key,
    required String value,
  });

  Future<String?> getCurrentStateBiometric({
    required String key,
  });
}
