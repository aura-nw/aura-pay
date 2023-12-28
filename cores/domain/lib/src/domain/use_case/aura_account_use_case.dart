import 'package:domain/src/core/aura_account_type.dart';
import 'package:domain/src/domain/entities/aura_account.dart';
import 'package:domain/src/domain/entities/requests/request.dart';
import 'package:domain/src/domain/repository/aura_account_repository.dart';

final class AuraAccountUseCase {
  final AuraAccountRepository _repository;

  const AuraAccountUseCase(this._repository);

  Future<List<AuraAccount>> getAccounts() {
    return _repository.getAccounts();
  }

  Future<AuraAccount?> getAccountByAddress({required String address,}) {
    return _repository.getAccountByAddress(address: address);
  }

  Future<AuraAccount?> getFirstAccount() {
    return _repository.getFirstAccount();
  }

  Future<void> saveAccount({
    required String address,
    required String accountName,
    required AuraAccountType type,
  }) {
    final SaveAccountRequestParameter parameter = SaveAccountRequestParameter(
      address: address,
      type: type,
      accountName: accountName,
    );
    return _repository.saveAccount(parameter);
  }

  Future<void> deleteAccount(int id) {
    return _repository.deleteAccount(id);
  }

  Future<void> updateAccount({
    String? accountName,
    String? address,
    AuraAccountType? type,
    AuraSmartAccountRecoveryMethod? method,
    String? value,
    String? subValue,
    required int id,
    bool useNullable = false,
  }) {
    final RenameAccountRequestParameter parameter =
        RenameAccountRequestParameter(
      id: id,
      accountName: accountName,
      address: address,
      type: type,
      method: method,
      value: value,
      subValue: subValue,
      useNullAble: useNullable,
    );
    return _repository.updateAccount(parameter);
  }

  Future<void> updateChangeIndex({
    required int id,
  }) {
    return _repository.updateChangeIndex(
      id: id,
    );
  }
}
