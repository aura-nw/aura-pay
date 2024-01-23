import 'package:data/src/data/resource/local/secure_storage_service.dart';
import 'package:data/src/data/resource/remote/auth_api_service.dart';
import 'package:domain/domain.dart';

final class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final StorageService _storageSecureService;

  const AuthRepositoryImpl(
    this._authApiService,
    this._storageSecureService,
  );

  @override
  Future<String> signIn({
    required Map<String, dynamic> body,
  }) async {
    final response = await _authApiService.signIn(
      body: body,
    );

    final data = response.handleResponse();

    return data['AccessToken'];
  }

  @override
  Future<String?> getAccessToken({
    required String key,
  }) {
    return _storageSecureService.getValue(
      key,
    );
  }

  @override
  Future<void> removeCurrentAccessToken({
    required String key,
  }) {
    return _storageSecureService.deleteValue(
      key,
    );
  }

  @override
  Future<void> saveAccessToken({
    required String key,
    required String accessToken,
  }) {
    return _storageSecureService.saveValue(
      key,
      accessToken,
    );
  }
}
