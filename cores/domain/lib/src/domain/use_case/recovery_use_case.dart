import 'package:domain/src/domain/entities/entities.dart';
import 'package:domain/src/domain/entities/requests/query_recovery_account_parameter.dart';
import 'package:domain/src/domain/repository/recovery_repository.dart';

final class RecoveryUseCase{
  final RecoveryRepository _repository;

  const RecoveryUseCase(this._repository);

  Future<List<PyxisRecoveryAccount>> getRecoveryAccountByAddress({
    required String recoveryAddress,
  }) {
    return _repository.getRecoveryAccountByAddress(
      queries: QueryRecoveryAccountParameter(
        recoveryAddress: recoveryAddress,
      ).toJson(),
    );
  }
}