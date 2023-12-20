import 'package:domain/src/domain/entities/entities.dart';
import 'package:domain/src/domain/entities/requests/query_transaction_parameter.dart';
import 'package:domain/src/domain/repository/repository.dart';

final class TransactionUseCase {
  final TransactionRepository _repository;

  const TransactionUseCase(this._repository);

  Future<List<PyxisTransaction>> getTransactions({
    required List<String> msgTypes,
    int ?heightLt,
    required int limit,
    required String environment,
    String ?sender,
    String? receive,
  }) async {
    return _repository.getTransactions(
      body: QueryTransactionParameter(
        sender: sender,
        receive: receive,
        msgTypes: msgTypes,
        limit: limit,
        heightLt: heightLt,
        environment: environment,
      ).toJson(),
      environment: environment,
    );
  }
}
