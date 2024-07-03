import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'key_store_db.g.dart';

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
