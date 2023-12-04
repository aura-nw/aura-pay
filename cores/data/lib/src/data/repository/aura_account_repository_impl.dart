import 'package:data/src/data/dto/aura_account_dto.dart';
import 'package:data/src/data/resource/local/local.dart';
import 'package:domain/domain.dart';

final class AuraAccountRepositoryImpl implements AuraAccountRepository {
  final AccountStorageService _accountStorageService;

  const AuraAccountRepositoryImpl(this._accountStorageService);

  @override
  Future<void> deleteAccount(int id) async {
    return _accountStorageService.deleteAccount(id);
  }

  @override
  Future<List<AuraAccount>> getAccounts() async {
    final accounts = await _accountStorageService.getAuraAccounts();

    return accounts.map((e) => e.toEntity).toList();
  }

  @override
  Future<void> saveAccount(SaveAccountRequestParameter parameter) {
    final AuraAccountDto accountDto = AuraAccountDto(
      type: parameter.type,
      address: parameter.address,
      name: parameter.accountName,
    );

    return _accountStorageService.saveAccount(accountDto);
  }

  @override
  Future<void> updateAccount(RenameAccountRequestParameter parameter) async {
    final AuraAccountDto? account =
        await _accountStorageService.getAccount(parameter.id);

    if (account == null) return;

    return _accountStorageService.updateAccount(
      account.copyWith(
        name: parameter.accountName,
      ),
    );
  }
}
