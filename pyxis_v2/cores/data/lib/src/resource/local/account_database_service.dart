import 'package:data/src/dto/account_dto.dart';

abstract interface class AccountDatabaseService{
  Future<AccountDto> add(AccountDto param);

  Future<void> delete(int id);

  Future<AccountDto> update(AccountDto param);

  Future<AccountDto?> get(int id);

  Future<List<AccountDto>> getAll();

  Future<List<AccountDto>> queryByAddress({
    required String address,
  });
}