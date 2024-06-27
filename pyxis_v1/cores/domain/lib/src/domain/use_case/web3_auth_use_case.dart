import 'package:domain/domain.dart';

class Web3AuthUseCase {
  final Web3AuthRepository _repository;

  const Web3AuthUseCase(this._repository);

  Future<GoogleAccount?> onLogin()async{
    return await _repository.login();
  }

  Future<void> onLogout()async{
    return _repository.signOut();
  }

  Future<String> getPrivateKey()async{
    return _repository.getUserPrivateKey();
  }
}