import 'package:domain/src/domain/entities/entities.dart';
import 'package:domain/src/domain/entities/requests/fee_grant_parameter.dart';
import 'package:domain/src/domain/repository/auth_repository.dart';
import 'package:domain/src/domain/repository/fee_grant_repository.dart';

final class FeeGrantUseCase {
  final FeeGrantRepository _feeGrantRepository;
  final AuthRepository _authRepository;

  const FeeGrantUseCase(this._feeGrantRepository, this._authRepository);

  Future<GrantFee> grantFee({
    required String pubKey,
    required String deviceId,
    required String smAddress,
    required String tokenKey,
  }) async {
    final String? accessToken = await _authRepository.getAccessToken(
      key: tokenKey,
    );

    final String bearerToken = 'Bearer $accessToken';

    return _feeGrantRepository.grantFee(
      body: FeeGrantParameter(
        pubKey: pubKey,
        deviceId: deviceId,
        granteeWallet: smAddress,
      ).toJson(),
      accessToken: bearerToken,
    );
  }
}
