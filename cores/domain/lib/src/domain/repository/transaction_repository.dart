import 'package:domain/src/domain/entities/entities.dart';

abstract interface class TransactionRepository {
  Future<List<PyxisTransaction>> getTransactions({
    required Map<String, dynamic> queries,
  });
}
