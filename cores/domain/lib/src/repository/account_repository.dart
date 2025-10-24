import 'package:domain/src/entities/account.dart';

import 'local_database_repository.dart';

abstract interface class AccountRepository
    extends LocalDatabaseRepository<Account> {

  Future<Account?> getFirstAccount();

  Future<void> updateChangeIndex({
    required int id,
  });
}
