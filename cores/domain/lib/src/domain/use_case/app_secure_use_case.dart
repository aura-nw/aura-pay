import 'package:domain/src/domain/repository/app_secure_repository.dart';

final class AppSecureUseCase {
  final AppSecureRepository _repository;

  const AppSecureUseCase(this._repository);

  Future<bool> hasPassCode({
    required String key,
  }) async{
    final String ?passcode = await getCurrentPassword(key: key);

    return passcode != null && passcode.isNotEmpty;
  }

  Future<String?> getCurrentPassword({
    required String key,
  }) async {
    return _repository.getCurrentPassword(key: key);
  }

  Future<void> savePassword({required String key, required String password}) {
    return _repository.savePassword(
      key: key,
      passWord: password,
    );
  }

  Future<bool> alReadySetBioMetric({
    required String key,
  }) async {
    String? value = await _repository.getBiometric(key: key);

    return value != null && value == 'true';
  }

  Future<void> setBioMetric({
    required String key,
    required bool setBioValue,
  }) async {
    return _repository.savePassword(
      key: key,
      passWord: setBioValue.toString(),
    );
  }
}
