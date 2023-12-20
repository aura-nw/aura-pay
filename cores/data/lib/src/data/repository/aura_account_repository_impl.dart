import 'package:data/src/data/dto/aura_account_dto.dart';
import 'package:data/src/data/resource/local/local.dart';
import 'package:domain/domain.dart';

final class AuraAccountRepositoryImpl implements AuraAccountRepository {
  final AccountDatabaseService _accountDatabaseService;

  const AuraAccountRepositoryImpl(this._accountDatabaseService);

  @override
  Future<void> deleteAccount(int id) async {
    return _accountDatabaseService.deleteAccount(id);
  }

  @override
  Future<List<AuraAccount>> getAccounts() async {
    final accounts = await _accountDatabaseService.getAuraAccounts();

    return accounts.map((e) => e.toEntity).toList();
  }

  @override
  Future<void> saveAccount(SaveAccountRequestParameter parameter) {
    return _accountDatabaseService.saveAccount(
      type: parameter.type,
      address: parameter.address,
      accountName: parameter.accountName,
    );
  }

  @override
  Future<void> updateAccount(
    RenameAccountRequestParameter parameter,
  ) async {
    return _accountDatabaseService.updateAccount(
      id: parameter.id,
      accountName: parameter.accountName,
      value: parameter.value,
      method: parameter.method,
      type: parameter.type,
      address: parameter.address,
      useNullAble: parameter.useNullAble,
      subValue: parameter.subValue,
    );
  }

  @override
  Future<AuraAccount?> getFirstAccount() async {
    final account = await _accountDatabaseService.getFirstAccount();

    return account?.toEntity;
  }
}
