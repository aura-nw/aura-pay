import 'package:data/src/data/dto/dto.dart';
import 'package:domain/domain.dart';

abstract interface class AccountDatabaseService {
  Future<AuraAccountDto?> getAccount(int id);
  Future<AuraAccountDto?> getAccountByAddress({required String address});

  Future<AuraAccountDto> saveAccount({
    required String address,
    required String accountName,
    required AuraAccountType type,
    bool needBackup = false,
    required AuraAccountCreateType createdType,
  });

  Future<List<AuraAccountDto>> getAuraAccounts();

  Future<void> deleteAccount(int id);

  Future<void> updateAccount({
    required int id,
    String? accountName,
    String? address,
    AuraAccountType? type,
    AuraSmartAccountRecoveryMethod? method,
    String? value,
    String? subValue,
    bool useNullAble = false,
    bool ?needBackup,
  });

  Future<AuraAccountDto?> getFirstAccount();

  Future<void> updateChangeIndex({
    required int id,
  });
}
