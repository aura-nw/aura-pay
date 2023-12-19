import 'package:domain/src/domain/entities/entities.dart';
import 'package:domain/src/domain/entities/requests/query_transaction_parameter.dart';
import 'package:domain/src/domain/repository/repository.dart';

final class TransactionUseCase {
  final TransactionRepository _repository;

  const TransactionUseCase(this._repository);

  Future<List<PyxisTransaction>> getTransactions({
    required List<String> events,
    required int page,
    required int limit,
  }) async {
    return _repository.getTransactions(
      queries: QueryTransactionParameter(
        events: events,
        limit: limit,
        page: page,
      ).toJson(),
    );
  }
}
