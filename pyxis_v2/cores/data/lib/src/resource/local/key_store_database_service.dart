import 'package:data/src/dto/key_store_dto.dart';

abstract interface class KeyStoreDatabaseService {
  Future<KeyStoreDto> add(KeyStoreDto param);

  Future<void> delete(int id);

  Future<KeyStoreDto> update(KeyStoreDto param);

  Future<KeyStoreDto?> get(int id);

  Future<List<KeyStoreDto>> getAll();
}