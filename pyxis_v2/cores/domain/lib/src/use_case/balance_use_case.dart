import 'package:domain/src/entities/balance.dart';
import 'package:domain/src/entities/request/update_balance_request.dart';
import 'package:domain/src/repository/balance_repository.dart';

import 'package:domain/src/entities/request/add_balance_request.dart';

final class BalanceUseCase {
  final BalanceRepository _balanceRepository;

  const BalanceUseCase(this._balanceRepository);

  Future<AccountBalance> add(AddAccountBalanceRequest param) async {
    return _balanceRepository.add(
      param,
    );
  }

  Future<void> delete(int id) {
    return _balanceRepository.delete(id);
  }

  Future<void> deleteAll() {
    return _balanceRepository.deleteAll();
  }

  Future<AccountBalance?> get(int id) async {
    return _balanceRepository.get(id);
  }

  Future<List<AccountBalance>> getAll() async {
    return _balanceRepository.getAll();
  }

  Future<String> getBalanceByAddress({required String address}) {
    return _balanceRepository.getBalanceByAddress(address: address);
  }

  Future<AccountBalance?> getByAccountID({
    required int accountId,
  }) {
    return _balanceRepository.getByAccountID(accountId: accountId);
  }

  Future<AccountBalance> update(UpdateAccountBalanceRequest param){
    return _balanceRepository.update(param);
  }
}
