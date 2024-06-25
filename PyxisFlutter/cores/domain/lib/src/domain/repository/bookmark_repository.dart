import 'package:domain/src/domain/entities/bookmark.dart';

abstract interface class BookMarkRepository {
  Future<BookMark> addNewBookMark({
    required Map<String, dynamic> json,
  });

  Future<void> deleteBookMark({
    required int id,
  });

  Future<List<BookMark>> getBookmarks();

  Future<BookMark?> getBookMarkByUrl({
    required String url,
  });
}
