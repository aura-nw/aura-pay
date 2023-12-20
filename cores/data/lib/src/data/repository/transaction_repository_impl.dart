import 'package:data/data.dart';
import 'package:domain/domain.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApiService _apiService;

  const TransactionRepositoryImpl(this._apiService);

  @override
  Future<List<PyxisTransaction>> getTransactions({
    required Map<String, dynamic> body,
    required String environment,
  }) async {
    final BaseResponseV2 response = await _apiService.getTransaction(
      body: body,
    );

    final data = response.handleResponse();

    // Get transaction from chain id or default
    String transaction = 'transaction';
    Map<String, dynamic> transactionMap = data[environment] ??
        {
          transaction: [],
        };

    final List<PyxisTransactionDto> transactions = List.empty(
      growable: true,
    );

    for (final transactionData in transactionMap[transaction]) {
      final PyxisTransactionDto transactionDto =
          PyxisTransactionDto.fromJson(transactionData);

      transactions.add(transactionDto);
    }

    return transactions
        .map(
          (e) => e.toEntity,
        )
        .toList();
  }
}
