import 'package:domain/src/domain/entities/address_book.dart';
import 'package:domain/src/domain/entities/requests/add_address_book_request.dart';
import 'package:domain/src/domain/entities/requests/update_address_book_request.dart';
import 'package:domain/src/domain/repository/address_book_repository.dart';

final class AddressBookUseCase {
  final AddressBookRepository _repository;

  const AddressBookUseCase(this._repository);

  Future<AddressBook> addAddressBook({
    required String address,
    required String name,
  }) async {
    final AddAddressBookRequest parameter = AddAddressBookRequest(
      name: name,
      address: address,
    );

    return _repository.addAddressBook(
      parameter: parameter,
    );
  }

  Future<AddressBook> update(
      {String? address, String? name, required int id}) async {
    final UpdateAddressBookRequest parameter = UpdateAddressBookRequest(
      name: name,
      address: address,
      id: id,
    );

    return _repository.update(
      parameter: parameter,
    );
  }

  Future<void> delete({
    required int id,
  }) {
    return _repository.delete(
      id: id,
    );
  }

  Future<List<AddressBook>> getAddressBooks (){
    return _repository.getAddressBooks();
  }
}
