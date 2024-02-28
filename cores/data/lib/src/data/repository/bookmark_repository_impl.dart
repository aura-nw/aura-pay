import 'package:data/src/data/dto/bookmark_dto.dart';
import 'package:data/src/data/resource/local/browser_database_service.dart';
import 'package:domain/domain.dart';

final class BookMarkRepositoryImpl
    implements BookMarkRepository {
  final LocalBrowserInterface _browserDataBaseService;

  const BookMarkRepositoryImpl(this._browserDataBaseService);

  @override
  Future<BookMark> addNewBookMark({
    required Map<String,dynamic> json,
  }) async{
    final bookMarkDto = await (_browserDataBaseService as BookMarkDataBaseService).add(
      parameter: json,
    );

    return bookMarkDto.toEntity;
  }

  @override
  Future<void> deleteBookMark({
    required int id,
  }) {
    return _browserDataBaseService.delete(
      id: id,
    );
  }

  @override
  Future<List<BookMark>> getBookmarks() async {
    final bookMarks = await (_browserDataBaseService as BookMarkDataBaseService).getAll();

    return bookMarks
        .map(
          (e) => e.toEntity,
        )
        .toList();
  }

  @override
  Future<BookMark?> getBookMarkByUrl({required String url}) async{
    final bookMarkDto = await (_browserDataBaseService as BookMarkDataBaseService).getBookMarkByUrl(url: url);

    return bookMarkDto?.toEntity;
  }
}
