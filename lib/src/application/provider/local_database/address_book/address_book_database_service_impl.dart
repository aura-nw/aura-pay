import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'address_book_db.dart';

final class AddressBookDatabaseServiceImpl
    implements AddressBookDatabaseService {
  final Isar _isar;

  const AddressBookDatabaseServiceImpl(this._isar);

  @override
  Future<AddressBookDto> addAddressBook({
    required String address,
    required String name,
  }) async {
    final AddressBookDb addressBookDb = AddressBookDb(
      addressDb: address,
      nameDb: name,
    );

    int id = addressBookDb.idDb;
    await _isar.writeTxn(() async {
      id = await _isar.addressBookDbs.put(addressBookDb);
    });

    return addressBookDb.copyWith(
      id: id,
    );
  }

  @override
  Future<void> delete({required int id}) async {
    await _isar.writeTxn(
      () async {
        await _isar.addressBookDbs.delete(id);
      },
    );
  }

  @override
  Future<AddressBookDto> update({
    required int id,
    String? address,
    String? name,
  }) async {
    AddressBookDb? addressBookDb = await _isar.addressBookDbs.get(id);

    if (addressBookDb == null) {
      return AddressBookDto(
        id: id,
        name: name ?? '',
        address: address ?? '',
      );
    }

    addressBookDb = addressBookDb.copyWith(
      address: address,
      name: name,
    );

    await _isar.writeTxn(
      () async {
        await _isar.addressBookDbs.put(
          addressBookDb!,
        );
      },
    );

    return addressBookDb;
  }

  @override
  Future<List<AddressBookDto>> getAddressBooks() {
    return _isar.addressBookDbs.where().findAll();
  }


}
