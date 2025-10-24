import 'package:data/src/dto/account_dto.dart';

import 'local_database_service.dart';

abstract interface class AccountDatabaseService extends LocalDatabaseService<AccountDto>{
  Future<AccountDto?> getFirstAccount();

  Future<void> updateChangeIndex({
    required int id,
  });
}