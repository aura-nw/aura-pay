import 'package:domain/src/entities/google_account.dart';

abstract interface class Web3AuthRepository{
  Future<GoogleAccount?> login();
  Future<void> logout();
  Future<String> getCurrentUserPrivateKey();
}