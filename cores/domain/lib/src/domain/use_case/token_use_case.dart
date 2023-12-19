import 'package:domain/src/domain/repository/repository.dart';

final class TokenUseCase {
  final TokenRepository _repository;

  const TokenUseCase(this._repository);

  Future<double> getTokenPrice({
    required String id,
    required String currency,
  }) async {
    return _repository.getTokenPrice(
      id: id,
      currency: currency,
    );
  }
}
