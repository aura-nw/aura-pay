import 'package:data/src/dto/account_dto.dart';
import 'package:data/src/dto/request/add_account_request_dto.dart';
import 'package:data/src/dto/request/update_account_request_dto.dart';

abstract interface class AccountDatabaseService{
  Future<AccountDto> add(AddAccountRequestDto param);

  Future<void> delete(int id);

  Future<AccountDto> update(UpdateAccountRequestDto param);

  Future<AccountDto?> get(int id);

  Future<List<AccountDto>> getAll();

  Future<List<AccountDto>> queryByAddress({
    required String address,
  });

  Future<AccountDto?> getFirstAccount();

  Future<void> deleteAll();
}