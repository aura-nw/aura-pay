import 'package:domain/src/domain/entities/address_book.dart';
import 'package:domain/src/domain/entities/requests/add_address_book_request.dart';
import 'package:domain/src/domain/entities/requests/update_address_book_request.dart';

abstract interface class AddressBookRepository {
  Future<AddressBook> addAddressBook({
    required AddAddressBookRequest parameter,
  });

  Future<AddressBook> update({
    required UpdateAddressBookRequest parameter,
  });

  Future<void> delete({
    required int id,
  });

  Future<List<AddressBook>> getAddressBooks();
}
