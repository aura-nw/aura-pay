import 'package:data/src/dto/balance_dto.dart';
import 'package:data/src/dto/request/add_balance_request_dto.dart';
import 'package:data/src/dto/request/update_balance_request_dto.dart';
import 'package:data/src/resource/local/balance_database_service.dart';
import 'package:data/src/resource/remote/balance_service.dart';
import 'package:domain/domain.dart';

final class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceDatabaseService _balanceDatabaseService;
  final BalanceService _balanceService;

  const BalanceRepositoryImpl(
      this._balanceService, this._balanceDatabaseService);

  @override
  Future<AccountBalance> add<P>(P param) async {
    final balanceDto = await _balanceDatabaseService.add(
      (param as AddAccountBalanceRequest).mapRequest,
    );

    return balanceDto.toEntity;
  }

  @override
  Future<void> delete(int id) {
    return _balanceDatabaseService.delete(id);
  }

  @override
  Future<void> deleteAll() {
    return _balanceDatabaseService.deleteAll();
  }

  @override
  Future<AccountBalance?> get(int id) async {
    final balanceDto = await _balanceDatabaseService.get(id);

    return balanceDto?.toEntity;
  }

  @override
  Future<List<AccountBalance>> getAll() async {
    final balancesDto = await _balanceDatabaseService.getAll();

    return balancesDto
        .map(
          (e) => e.toEntity,
        )
        .toList();
  }

  @override
  Future<String> getBalanceByAddress({required String address}) {
    return _balanceService.getBalanceByAddress(address: address);
  }

  @override
  Future<AccountBalance> update<P>(P param) async{
    final balanceDto = await _balanceDatabaseService.update(
      (param as UpdateAccountBalanceRequest).mapRequest,
    );

    return balanceDto.toEntity;
  }

  @override
  Future<AccountBalance?> getByAccountID({required int accountId}) async{
    final accountBalance = await _balanceDatabaseService.getByAccountID(accountId: accountId);
    
    return accountBalance?.toEntity;
  }
}
