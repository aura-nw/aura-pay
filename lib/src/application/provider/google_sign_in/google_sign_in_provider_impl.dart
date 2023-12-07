import 'package:data/data.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProviderImpl implements GoogleSignInProvider {
  final GoogleSignIn _googleSignIn;

  const GoogleSignInProviderImpl(
    this._googleSignIn,
  );

  @override
  Future<String?> getCurrentAccessToken() async {
    return (await _googleSignIn.currentUser?.authentication)?.accessToken;
  }

  @override
  Future<GoogleAccountDto?> loginWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();

    if (googleAccount == null) return null;

    return GoogleAccountDto(
      id: googleAccount.id,
      email: googleAccount.email,
      displayName: googleAccount.displayName,
      photoUrl: googleAccount.photoUrl,
      serverAuthCode: googleAccount.serverAuthCode,
    );
  }

  @override
  Future<GoogleAccountDto?> signOut() async{
    final googleAccount = await _googleSignIn.signOut();

    if (googleAccount == null) return null;

    return GoogleAccountDto(
      id: googleAccount.id,
      email: googleAccount.email,
      displayName: googleAccount.displayName,
      photoUrl: googleAccount.photoUrl,
      serverAuthCode: googleAccount.serverAuthCode,
    );
  }
}
