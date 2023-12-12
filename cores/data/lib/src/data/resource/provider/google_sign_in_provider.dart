import 'package:data/src/data/dto/dto.dart';

abstract interface class GoogleSignInProvider {

  Future<GoogleAccountDto?> login();

  Future<void> signOut();

  Future<String> getUserPrivateKey();
}