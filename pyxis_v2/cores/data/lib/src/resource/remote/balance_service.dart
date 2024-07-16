abstract interface class BalanceService {
  Future<String> getBalanceByAddress({
    required String address,
  });
}