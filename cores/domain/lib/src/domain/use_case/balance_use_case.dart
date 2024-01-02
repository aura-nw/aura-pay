import 'package:domain/domain.dart';

final class BalanceUseCase {
  final BalanceRepository _repository;

  const BalanceUseCase(this._repository);

  Future<List<PyxisBalance>> getBalances({
    required String address,
    required String environment,
  }) async {
    final QueryBalancesParameter parameter = QueryBalancesParameter(
      address: address,
      environment: environment,
    );
    return _repository.getBalances(
      body: parameter.toJson(),
      environment: environment,
    );
  }
}
