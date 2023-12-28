import 'package:domain/domain.dart';

final class TransactionUseCase {
  final TransactionRepository _repository;

  const TransactionUseCase(this._repository);

  Future<List<PyxisTransaction>> getTransactions({
    required List<String> msgTypes,
    int? heightLt,
    required int limit,
    required String environment,
    String? sender,
    String? receive,
    required QueryTransactionType queryTransactionType,
  }) async {
    return _repository.getTransactions(
      body: QueryTransactionParameter(
        sender: sender,
        receive: receive,
        msgTypes: msgTypes,
        limit: limit,
        heightLt: heightLt,
        environment: environment,
        queryType: queryTransactionType,
      ).toJson(),
      environment: environment,
    );
  }

  Future<TransactionInformation> getTransactionDetail({
    required String txHash,
    required String environment,
  }) async {
    return _repository.getTransactionDetail(
      body: QueryTransactionDetailParameter(
        environment: environment,
        txHash: txHash,
      ).toJson(),
      environment: environment,
    );
  }
}
