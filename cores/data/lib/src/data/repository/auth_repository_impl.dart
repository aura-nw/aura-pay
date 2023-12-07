import 'package:data/src/data/dto/google_account_dto.dart';
import 'package:data/src/data/resource/provider/provider.dart';
import 'package:domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignInProvider _authApiService;

  const AuthRepositoryImpl(this._authApiService);

  @override
  Future<GoogleAccount?> signInWithGoogle() async {
    final GoogleAccountDto? googleAccount =
        await _authApiService.loginWithGoogle();

    if (googleAccount != null) {}

    return googleAccount?.toEntities;
  }

  @override
  Future<bool> signOut() async {
    final GoogleAccountDto? googleAccount = await _authApiService.signOut();

    return googleAccount != null;
  }

  @override
  Future<String?> getCurrentAccessToken() async{
    return _authApiService.getCurrentAccessToken();
  }
}
