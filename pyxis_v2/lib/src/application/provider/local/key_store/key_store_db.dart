import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'key_store_db.g.dart';

extension KeyStoreDbExtension on KeyStoreDb {
  KeyStoreDb copyWith({
    String? keyName,
    int ?id,
  }) {
    return KeyStoreDb(
      keyName: keyName ?? this.keyName,
      keyId: id ?? keyId,
    );
  }
}

@Collection(
  inheritance: false,
)
final class KeyStoreDb extends KeyStoreDto {
  final Id keyId;
  final String keyName;

  KeyStoreDb({
    required this.keyName,
    this.keyId = Isar.autoIncrement,
  }) : super(
          id: keyId,
          key: keyName,
        );
}
