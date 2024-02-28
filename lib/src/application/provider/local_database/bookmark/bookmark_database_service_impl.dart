import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'bookmark_db.dart';

final class BookMarkDatabaseServiceImpl implements BookMarkDataBaseService {
  final Isar _isar;

  const BookMarkDatabaseServiceImpl(this._isar);

  @override
  Future<BookMarkDto> add({required Map<String, dynamic> parameter}) async {
    final BookMarkDb bookMark = BookMarkDb.fromJson(
      parameter,
    );

    int id = bookMark.id;

    await _isar.writeTxn(() async {
      id = await _isar.bookMarkDbs.put(bookMark);
    });

    return bookMark.copyWithId(id);
  }

  @override
  Future<void> delete({
    required int id,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.bookMarkDbs.delete(id);
    });
  }

  @override
  Future<List<BookMarkDto>> getAll() {
    return _isar.bookMarkDbs.where().findAll();
  }

  @override
  Future<BookMarkDto?> getBookMarkByUrl({
    required String url,
  }) async {
    return _isar.bookMarkDbs.filter().bookMarkUrlEqualTo(url).findFirst();
  }
}
