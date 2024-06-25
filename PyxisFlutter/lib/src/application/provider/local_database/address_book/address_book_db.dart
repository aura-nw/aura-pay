import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'address_book_db.g.dart';

extension AddressBookDbExtension on AddressBookDb {
  AddressBookDb copyWith({
    int? id,
    String? name,
    String? address,
  }) {
    return AddressBookDb(
      addressDb: address ?? addressDb,
      nameDb: name ?? nameDb,
      idDb: id ?? idDb,
    );
  }
}

@Collection(
  inheritance: false,
)
class AddressBookDb extends AddressBookDto {
  final String addressDb;
  final String nameDb;
  final Id idDb;

  const AddressBookDb({
    required this.addressDb,
    required this.nameDb,
    this.idDb = Isar.autoIncrement,
  }) : super(
          id: idDb,
          name: nameDb,
          address: addressDb,
        );
}
