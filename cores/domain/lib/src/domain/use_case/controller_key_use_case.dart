import 'package:domain/src/domain/repository/controller_key_repository.dart';

final class ControllerKeyUseCase {
  final ControllerKeyRepository _repository;

  const ControllerKeyUseCase(this._repository);

  Future<void> saveKey({
    required String address,
    required String key,
  }) async {
    return _repository.saveKey(
      address: address,
      key: key,
    );
  }

  Future<bool> containAddress({
    required String address,
  }) async {
    return _repository.containAddress(address: address);
  }

  Future<String?> getKey({
    required String address,
  }) async {
    return _repository.getKey(address: address);
  }

  Future<void> deleteKey({
    required String address,
  }) async {
    return _repository.deleteKey(
      address: address,
    );
  }
}
