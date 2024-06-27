import 'package:domain/src/domain/entities/entities.dart';
import 'package:domain/src/domain/entities/requests/query_recovery_account_parameter.dart';
import 'package:domain/src/domain/repository/auth_repository.dart';
import 'package:domain/src/domain/repository/recovery_repository.dart';

final class RecoveryUseCase {
  final RecoveryRepository _repository;
  final AuthRepository _authRepository;

  const RecoveryUseCase(
    this._repository,
    this._authRepository,
  );

  Future<List<PyxisRecoveryAccount>> getRecoveryAccountByAddress({
    required String recoveryAddress,
    required String tokenKey,
  }) async {
    final String? accessToken = await _authRepository.getAccessToken(
      key: tokenKey,
    );

    final String bearerToken = 'Bearer $accessToken';
    return _repository.getRecoveryAccountByAddress(
      queries: QueryRecoveryAccountParameter(
        recoveryAddress: recoveryAddress,
      ).toJson(),
      accessToken: bearerToken,
    );
  }
}
