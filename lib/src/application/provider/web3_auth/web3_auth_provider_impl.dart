import 'package:data/data.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class Web3AuthProviderImpl implements GoogleSignInProvider {
  const Web3AuthProviderImpl();

  @override
  Future<String> getUserPrivateKey() async {
    return Web3AuthFlutter.getPrivKey();
  }

  @override
  Future<GoogleAccountDto?> login() async {
    final response = await Web3AuthFlutter.login(
      LoginParams(
        loginProvider: Provider.google,
      ),
    );

    if (response.userInfo == null) return null;

    final userInfo = response.userInfo!;

    return GoogleAccountDto(
      idToken: userInfo.idToken!,
      email: userInfo.email!,
      name: userInfo.name,
      profileImage: userInfo.profileImage,
      oAuthIdToken: userInfo.oAuthIdToken,
      oAuthAccessToken: userInfo.oAuthAccessToken,
    );
  }

  @override
  Future<void> signOut() async {
    return Web3AuthFlutter.logout();
  }
}
