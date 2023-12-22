import 'package:data/data.dart';
import 'package:domain/domain.dart';

final class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceApiService _balanceApiService;

  const BalanceRepositoryImpl(
    this._balanceApiService,
  );

  @override
  Future<double> getTokenPrice() async {
    final response = await _balanceApiService.getTokenPrice();

    return double.tryParse( response.data) ?? 0;
  }

  @override
  Future<List<PyxisBalance>> getBalances({
    required Map<String, dynamic> body,
    required String environment,
  }) async {
    final response = await _balanceApiService.getBalances(
      body: body,
    );

    final data = response.handleResponse();

    // Get account or null set to default
    final account = data[environment]['account']?[0] ??
        {
          'balances': [],
        };

    final List<PyxisBalanceDto> balances = List.empty(growable: true);

    for (final json in account['balances']) {
      final PyxisBalanceDto balanceDto = PyxisBalanceDto.fromJson(json);

      balances.add(balanceDto);
    }

    return balances.map((e) => e.toEntity).toList();
  }
}
