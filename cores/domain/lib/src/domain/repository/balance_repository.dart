import 'package:domain/src/domain/entities/pyxis_balance.dart';

abstract class BalanceRepository {
  Future<double> getTokenPrice();

  Future<List<PyxisBalance>> getBalances({
    required Map<String, dynamic> body,
    required String environment,
  });
}
