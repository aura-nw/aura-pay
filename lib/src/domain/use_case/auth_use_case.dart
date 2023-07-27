import 'package:pyxis_mobile/src/domain/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _repository;

  const AuthUseCase(this._repository);

  Future<void> onLogin()async{
    await _repository.onLogin();
  }
}