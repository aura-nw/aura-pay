import 'package:domain/domain.dart';

class AuthUseCase {
  final AuthRepository _repository;

  const AuthUseCase(this._repository);

  Future<GoogleAccount?> onLogin()async{
    return await _repository.signInWithGoogle();
  }

  Future<bool> onLogout()async{
    return _repository.signOut();
  }

  Future<String?> getCurrentAccessToken()async{
    return _repository.getCurrentAccessToken();
  }
}