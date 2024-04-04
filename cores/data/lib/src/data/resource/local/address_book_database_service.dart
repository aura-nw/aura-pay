import 'package:data/src/data/dto/address_book_dto.dart';

abstract interface class AddressBookDatabaseService {
  Future<AddressBookDto> addAddressBook({
    required String address,
    required String name,
  });

  Future<AddressBookDto> update({
    required int id,
    String? address,
    String? name,
  });

  Future<void> delete({
    required int id,
  });

  Future<List<AddressBookDto>> getAddressBooks();
}
