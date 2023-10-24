import 'package:google_sign_in/google_sign_in.dart';

final class AuthApiService{
  final GoogleSignIn _googleSignIn;

  const AuthApiService(this._googleSignIn);

  Future<GoogleSignInAccount?> loginWithGoogle()async{
    return _googleSignIn.signIn();
  }

  Future<GoogleSignInAccount?> signOut()async{
    return _googleSignIn.signOut();
  }
}