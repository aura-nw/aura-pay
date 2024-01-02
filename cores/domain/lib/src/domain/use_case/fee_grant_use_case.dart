import 'package:domain/src/domain/entities/requests/fee_grant_parameter.dart';
import 'package:domain/src/domain/repository/fee_grant_repository.dart';

final class FeeGrantUseCase{
  final FeeGrantRepository _repository;

  const FeeGrantUseCase(this._repository);

  Future<void> grantFee({
    required String pubKey,
    required String deviceId,
    required String smAddress,
  }) async {
    return _repository.grantFee(
      body: FeeGrantParameter(
        pubKey: pubKey,
        deviceId: deviceId,
        granteeWallet: smAddress,
      ).toJson(),
    );
  }
}