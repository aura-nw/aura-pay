import 'package:data/src/data/resource/remote/auth_api_service.dart';
import 'package:domain/domain.dart';

final class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  const AuthRepositoryImpl(this._authApiService);
  @override
  Future<String> signIn({
    required Map<String, dynamic> body,
  }) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
