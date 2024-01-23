import 'package:data/src/data/dto/dto.dart';
import 'package:data/src/data/resource/remote/api_service.dart';
import 'package:domain/domain.dart';

final class RecoveryRepositoryImpl implements RecoveryRepository {
  final RecoveryApiService _apiService;

  const RecoveryRepositoryImpl(this._apiService);

  @override
  Future<List<PyxisRecoveryAccount>> getRecoveryAccountByAddress({
    required Map<String, dynamic> queries,
    required String accessToken,
  }) async {
    final response = await _apiService.getRecoveryAccountByAddress(
      queries: queries,
      accessToken: accessToken,
    );

    final data = response.data ?? [];

    final List<PyxisRecoveryAccountDto> accountsDto =
        List.empty(growable: true);

    for (final json in data) {
      final PyxisRecoveryAccountDto accountDto =
          PyxisRecoveryAccountDto.fromJson(json);

      accountsDto.add(accountDto);
    }

    return accountsDto.map((e) => e.toEntity).toList();
  }
}
