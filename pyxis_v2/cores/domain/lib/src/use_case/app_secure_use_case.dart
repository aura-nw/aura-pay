import 'package:domain/src/repository/app_secure_repository.dart';

final class AppSecureUseCase {
  final AppSecureRepository _repository;

  const AppSecureUseCase(this._repository);

  Future<bool> hadPassCode({
    required String key,
  }) async {
    final String? passcode = await getCurrentPassword(key: key);

    return passcode != null && passcode.isNotEmpty;
  }

  Future<String?> getCurrentPassword({
    required String key,
  }) async {
    return _repository.getCurrentPassword(key: key);
  }

  Future<void> savePassword({
    required String key,
    required String password,
  }) {
    return _repository.savePassword(
      key: key,
      passWord: password,
    );
  }

  Future<bool> isEnableBiometric({
    required String key,
  }) async {
    String? value = await _repository.getCurrentStateBiometric(key: key);

    return value != null && value == 'true';
  }

  Future<void> setBioMetric({
    required String key,
    required bool setBioValue,
  }) async {
    return _repository.setEnableBiometric(
      key: key,
      value: setBioValue.toString(),
    );
  }

  Future<bool> canAuthenticateWithBiometrics() {
    return _repository.canAuthenticateWithBiometrics();
  }

  Future<bool> requestBiometric({
    String? localizedReason,
    String? androidSignTitle,
    String? cancelButton,
  }) {
    return _repository.requestBiometric(
      androidSignTitle: androidSignTitle,
      cancelButton: cancelButton,
      localizedReason: localizedReason,
    );
  }
}
