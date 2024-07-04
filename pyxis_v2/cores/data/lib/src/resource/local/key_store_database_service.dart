import 'package:data/src/dto/key_store_dto.dart';
import 'package:data/src/dto/request/add_key_store_request_dto.dart';
import 'package:data/src/dto/request/update_key_store_request_dto.dart';

abstract interface class KeyStoreDatabaseService {
  Future<KeyStoreDto> add(AddKeyStoreRequestDto param);

  Future<void> delete(int id);

  Future<KeyStoreDto> update(UpdateKeyStoreRequestDto param);

  Future<KeyStoreDto?> get(int id);

  Future<List<KeyStoreDto>> getAll();
}