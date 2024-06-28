import 'package:data/data.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class Web3AuthProviderImpl implements Web3AuthProvider {
  const Web3AuthProviderImpl();

  @override
  Future<String> getCurrentUserPrivateKey() async {
    return Web3AuthFlutter.getPrivKey();
  }

  @override
  Future<GoogleAccountDto?> login() async {
    final Web3AuthResponse response = await Web3AuthFlutter.login(
      LoginParams(
        /// maybe change later
        loginProvider: Provider.google,
      ),
    );

    if (response.userInfo == null) return null;

    final userInfo = response.userInfo!;

    return GoogleAccountDto(
      idToken: userInfo.idToken ?? '',
      email: userInfo.email ?? '',
      name: userInfo.name,
      profileImage: userInfo.profileImage,
      oAuthIdToken: userInfo.oAuthIdToken,
      oAuthAccessToken: userInfo.oAuthAccessToken,
    );
  }

  @override
  Future<void> logout() async {
    return Web3AuthFlutter.logout();
  }
}
