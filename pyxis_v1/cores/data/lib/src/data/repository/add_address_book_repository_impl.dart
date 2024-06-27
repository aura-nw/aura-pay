import 'package:data/src/data/dto/address_book_dto.dart';
import 'package:data/src/data/resource/local/address_book_database_service.dart';
import 'package:domain/domain.dart';

final class AddressBookRepositoryImpl implements AddressBookRepository {
  final AddressBookDatabaseService _service;

  const AddressBookRepositoryImpl(this._service);

  @override
  Future<AddressBook> addAddressBook({
    required AddAddressBookRequest parameter,
  }) async {
    final AddressBookDto addressBookDto = await _service.addAddressBook(
      address: parameter.address,
      name: parameter.name,
    );

    return addressBookDto.toEntity;
  }

  @override
  Future<void> delete({
    required int id,
  }) {
    return _service.delete(
      id: id,
    );
  }

  @override
  Future<AddressBook> update({
    required UpdateAddressBookRequest parameter,
  }) async {
    final AddressBookDto addressBookDto = await _service.update(
      address: parameter.address,
      name: parameter.name,
      id: parameter.id,
    );

    return addressBookDto.toEntity;
  }

  @override
  Future<List<AddressBook>> getAddressBooks()async{
    final addressBooksDto = await _service.getAddressBooks();

    return addressBooksDto.map((e) => e.toEntity).toList();
  }
}
