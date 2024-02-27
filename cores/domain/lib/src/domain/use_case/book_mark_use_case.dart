import 'package:domain/src/domain/entities/bookmark.dart';
import 'package:domain/src/domain/entities/requests/save_bookmark_parameter.dart';
import 'package:domain/src/domain/repository/bookmark_repository.dart';

final class BookMarkUseCase {
  final BookMarkRepository _repository;

  const BookMarkUseCase(this._repository);

  Future<void> addBookMark({
    required String logo,
    required String name,
    String? description,
    required String url,
  }) {
    final SaveBookMarkParameter parameter = SaveBookMarkParameter(
      logo: logo,
      name: name,
      url: url,
      description: description,
    );

    return _repository.addNewBookMark(
      json: parameter.toJson(),
    );
  }

  Future<void> deleteBookMark({
    required int id,
  }) {
    return _repository.deleteBookMark(
      id: id,
    );
  }

  Future<List<BookMark>> getBookmarks() {
    return _repository.getBookmarks();
  }

  Future<BookMark?> getBookMarkByUrl({required String url,}){
    return _repository.getBookMarkByUrl(url: url);
  }
}
