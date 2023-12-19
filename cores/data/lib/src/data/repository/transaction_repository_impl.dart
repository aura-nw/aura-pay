import 'package:data/data.dart';
import 'package:domain/domain.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApiService _apiService;

  const TransactionRepositoryImpl(this._apiService);

  @override
  Future<List<PyxisTransaction>> getTransactions({
    required Map<String, dynamic> queries,
  }) async {
    final TransactionBaseResponse response = await _apiService.getTransaction(
      queries: queries,
    );

    List<PyxisTransactionDto> transactions = response.txResponse.map((e) {
      final int txIndex = response.txResponse.indexOf(e);
      final Map<String, dynamic> tx = response.txs[txIndex];

      final PyxisTransactionDto transaction = PyxisTransactionDto.fromJson(e);

      final Map<String, dynamic> authInfo = tx['auth_info'];

      final String fee = authInfo['fee']?['amount']?[0]?['amount'] ?? '';

      return transaction.copyWith(
        memo: tx['body']?['memo'],
        fee: fee,
        msg: tx['body']['messages'][0],
      );
    }).toList();

    return transactions
        .map(
          (e) => e.toEntity,
        )
        .toList();
  }
}
