import 'package:data/src/data/dto/dto.dart';

abstract interface class GoogleSignInProvider {

  Future<GoogleAccountDto?> loginWithGoogle();

  Future<GoogleAccountDto?> signOut();

  Future<String?> getCurrentAccessToken();
}