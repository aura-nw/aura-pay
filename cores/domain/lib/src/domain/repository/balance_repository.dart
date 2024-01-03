import 'package:domain/src/domain/entities/pyxis_balance.dart';

abstract interface class BalanceRepository {
  Future<List<PyxisBalance>> getBalances({
    required Map<String, dynamic> body,
    required String environment,
  });
}
