import 'package:domain/src/domain/entities/google_account.dart';

abstract class AuthRepository{
  Future<GoogleAccount?> signInWithGoogle();
  Future<bool> signOut();
  Future<String?> getCurrentAccessToken();
}