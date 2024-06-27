import 'package:data/src/data/dto/dto.dart';

abstract interface class Web3AuthProvider {

  Future<GoogleAccountDto?> login();

  Future<void> signOut();

  Future<String> getUserPrivateKey();
}