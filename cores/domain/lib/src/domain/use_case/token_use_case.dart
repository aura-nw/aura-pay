import 'package:domain/src/domain/repository/token_repository.dart';

final class TokenUseCase {
  final TokenRepository _repository;

  const TokenUseCase(this._repository);


  Future<double> getAuraTokenPrice() async {
    return _repository.getAuraTokenPrice();
  }
}