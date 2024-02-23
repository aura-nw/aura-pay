import 'package:data/src/data/dto/browser_dto.dart';
import 'package:data/src/data/dto/bookmark_dto.dart';

abstract interface class LocalBrowserInterface<P,R>{
  Future<void> add({
    required P parameter
  });

  Future<void> delete({
    required int id,
  });

  Future<List<R>> getAll();
}

abstract interface class BookMarkDataBaseService
    implements
        LocalBrowserInterface<Map<String, dynamic>, BookMarkDto> {}

abstract interface class BrowserDatabaseService
    implements LocalBrowserInterface<Map<String, dynamic>, BrowserDto> {
  Future<void> clear();
}
