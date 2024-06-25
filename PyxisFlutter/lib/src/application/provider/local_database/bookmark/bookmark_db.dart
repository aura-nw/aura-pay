import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'bookmark_db.g.dart';

@Collection(
  inheritance: false,
)
class BookMarkDb extends BookMarkDto {
  final Id bookMarkId;
  final String bookMarkName;
  final String bookMarkLogo;
  final String? bookMarkDescription;
  final String bookMarkUrl;

  BookMarkDb({
    this.bookMarkId = Isar.autoIncrement,
    required this.bookMarkName,
    required this.bookMarkLogo,
    required this.bookMarkUrl,
    this.bookMarkDescription,
  }) : super(
          id: bookMarkId,
          name: bookMarkName,
          logo: bookMarkLogo,
          url: bookMarkUrl,
          description: bookMarkDescription,
        );

  factory BookMarkDb.fromJson(Map<String, dynamic> json) {
    return BookMarkDb(
      bookMarkName: json['name'],
      bookMarkLogo: json['logo'],
      bookMarkUrl: json['url'],
      bookMarkDescription: json['description'],
    );
  }

  BookMarkDb copyWithId(int id) {
    return BookMarkDb(
      bookMarkName: bookMarkName,
      bookMarkLogo: bookMarkLogo,
      bookMarkUrl: bookMarkUrl,
      bookMarkDescription: bookMarkDescription,
      bookMarkId: id,
    );
  }
}
