import 'package:domain/src/entities/google_account.dart';
import 'package:domain/src/repository/web3_auth_repository.dart';

final class Web3AuthUseCase {
  final Web3AuthRepository _repository;

  const Web3AuthUseCase(this._repository);

  Future<GoogleAccount?> onLogin()async{
    return await _repository.login();
  }

  Future<void> logout()async{
    return _repository.logout();
  }

  Future<String> getPrivateKey()async{
    return _repository.getCurrentUserPrivateKey();
  }
}