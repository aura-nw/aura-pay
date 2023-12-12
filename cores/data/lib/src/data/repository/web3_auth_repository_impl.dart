import 'package:data/src/data/dto/google_account_dto.dart';
import 'package:data/src/data/resource/provider/provider.dart';
import 'package:domain/domain.dart';

class Web3AuthRepositoryImpl implements Web3AuthRepository {
  final GoogleSignInProvider _authApiService;

  const Web3AuthRepositoryImpl(this._authApiService);


  @override
  Future<void> signOut() async {
    return _authApiService.signOut();
  }


  @override
  Future<String> getUserPrivateKey() {
    return _authApiService.getUserPrivateKey();
  }

  @override
  Future<GoogleAccount?> login() async{
    final GoogleAccountDto? googleAccount =
        await _authApiService.login();

    if (googleAccount != null) {}

    return googleAccount?.toEntities;
  }
}
