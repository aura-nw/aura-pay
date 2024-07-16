abstract interface class BalanceService {
  Future<String> getEvmBalanceByAddress({
    required String address,
  });

  Future<String> getCosmosBalanceByAddress({
    required String address,
  });
}