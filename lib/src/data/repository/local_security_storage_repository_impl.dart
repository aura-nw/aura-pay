import 'package:pyxis_mobile/src/domain/repository/local_security_storage_repository.dart';

final class LocalSecurityRepositoryImpl
    implements LocalSecurityStorageRepository {
  @override
  Future<bool> constantKey({required String key}) {
    // TODO: implement constantKey
    throw UnimplementedError();
  }

  @override
  Future<void> deleteValue({required String key}) {
    // TODO: implement deleteValue
    throw UnimplementedError();
  }

  @override
  Future<String> getValue<T>({required String key}) {
    // TODO: implement getValue
    throw UnimplementedError();
  }

  @override
  Future<void> saveValue({required String key, required String value}) {
    // TODO: implement saveValue
    throw UnimplementedError();
  }
}
