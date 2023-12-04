import 'package:data/src/data/resource/local/local.dart';
import 'package:domain/domain.dart';

class ControllerKeyRepositoryImpl implements ControllerKeyRepository{
  final SecureStorageService _service;

  const ControllerKeyRepositoryImpl(this._service);

  @override
  Future<bool> containAddress({required String address}) async{
    return _service.constantValue(address);
  }

  @override
  Future<void> deleteKey({required String address}) {
    return _service.deleteValue(address);
  }

  @override
  Future<String?> getKey({required String address}) async{
    return await _service.getValue(address);
  }

  @override
  Future<void> saveKey({required String address, required String key}) {
    return _service.saveValue(address, key);
  }

}