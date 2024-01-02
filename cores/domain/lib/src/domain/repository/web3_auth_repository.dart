import 'package:domain/src/domain/entities/google_account.dart';

abstract interface class Web3AuthRepository{
  Future<GoogleAccount?> login();
  Future<void> signOut();
  Future<String> getUserPrivateKey();
}