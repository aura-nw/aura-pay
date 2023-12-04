import 'package:domain/src/domain/entities/aura_account.dart';
import 'package:domain/src/domain/entities/requests/request.dart';

abstract interface class AuraAccountRepository{
  Future<List<AuraAccount>> getAccounts();

  Future<void> saveAccount(SaveAccountRequestParameter parameter);

  Future<void> deleteAccount(int id);

  Future<void> updateAccount(RenameAccountRequestParameter parameter);
}