import 'package:data/src/dto/google_account_dto.dart';

abstract interface class Web3AuthProvider {

  Future<GoogleAccountDto?> login();

  Future<void> logout();

  Future<String> getCurrentUserPrivateKey();
}