import 'package:pyxis_mobile/src/domain/repository/local_storage_repository.dart';

final class LocalSecurityRepositoryImpl implements LocalStorageRepository{
  @override
  Future<bool> constantKey({required String key}) {
    // TODO: implement constantKey
    throw UnimplementedError();
  }

  @override
  Future<T?> getValue<T>({required String key}) {
    // TODO: implement getValue
    throw UnimplementedError();
  }

  @override
  Future<void> saveValue<T>({required String key, required T value}) {
    // TODO: implement saveValue
    throw UnimplementedError();
  }


}