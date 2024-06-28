import 'package:data/src/dto/google_account_dto.dart';
import 'package:data/src/resource/provider/web3_auth_provider.dart';
import 'package:domain/domain.dart';

class Web3AuthRepositoryImpl implements Web3AuthRepository {
  final Web3AuthProvider _authApiService;

  const Web3AuthRepositoryImpl(this._authApiService);


  @override
  Future<void> logout() async {
    return _authApiService.logout();
  }


  @override
  Future<String> getCurrentUserPrivateKey() {
    return _authApiService.getCurrentUserPrivateKey();
  }

  @override
  Future<GoogleAccount?> login() async{
    final GoogleAccountDto? googleAccount =
        await _authApiService.login();

    return googleAccount?.toEntities;
  }
}
