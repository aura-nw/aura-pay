import 'package:data/src/data/resource/local/local.dart';
import 'package:domain/domain.dart';

final class AppSecureRepositoryImpl implements AppSecureRepository{
  final SecureStorageService _service;

  const AppSecureRepositoryImpl(this._service);
  @override
  Future<String?> getCurrentPassword({required String key}) async{
    return _service.getValue(key);
  }

  @override
  Future<void> savePassword({required String key, required String passWord}) {
    return _service.saveValue(key, passWord);
  }

  @override
  Future<bool> hasPassCode({required String key}) {
    return _service.constantValue(key);
  }

}