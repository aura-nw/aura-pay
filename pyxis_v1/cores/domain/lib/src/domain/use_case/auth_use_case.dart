import 'package:domain/src/domain/entities/requests/sign_in_parameter.dart';
import 'package:domain/src/domain/repository/auth_repository.dart';

final class AuthUseCase {
  final AuthRepository _repository;

  const AuthUseCase(this._repository);

  Future<String> signIn({
    required String deviceId,
    required String unixTimestamp,
    required String signature,
  }) async {
    final SignInParameter parameter = SignInParameter(
      deviceId: deviceId,
      data: unixTimestamp,
      signature: signature,
    );
    final String token = await _repository.signIn(
      body: parameter.toJson(),
    );

    return token;
  }

  Future<void> saveAccessToken({
    required String key,
    required String accessToken,
  }) async {
    return _repository.saveAccessToken(
      key: key,
      accessToken: accessToken,
    );
  }

  Future<String?> getCurrentAccessToken({
    required String key,
  }) async {
    return _repository.getAccessToken(
      key: key,
    );
  }

  Future<void> removeCurrentAccessToken({
    required String key,
  }) async {
    return _repository.removeCurrentAccessToken(
      key: key,
    );
  }
}
