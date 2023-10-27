import 'package:data/src/data/dto/google_account_dto.dart';
import 'package:data/src/data/resource/remote/auth_api_service.dart';
import 'package:domain/domain.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  const AuthRepositoryImpl(this._authApiService);

  @override
  Future<GoogleAccount?> signInWithGoogle() async {
    final GoogleSignInAccount? googleAccount =
        await _authApiService.loginWithGoogle();

    if (googleAccount != null) {}

    return googleAccount?.toDto.toEntities;
  }

  @override
  Future<bool> signOut() async {
    final GoogleSignInAccount? googleAccount = await _authApiService.signOut();

    return googleAccount != null;
  }

  @override
  Future<String?> getCurrentAccessToken() async{
    return _authApiService.getCurrentAccessToken();
  }
}
