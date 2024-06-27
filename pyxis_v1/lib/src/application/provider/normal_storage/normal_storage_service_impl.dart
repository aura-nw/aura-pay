import 'package:data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class NormalStorageServiceImpl implements NormalStorageService {
  final SharedPreferences _storage;

  const NormalStorageServiceImpl(
    this._storage,
  );

  @override
  Future<bool> constantValue(String key) async {
    return _storage.containsKey(
      key,
    );
  }

  @override
  Future<void> deleteValue(String key) {
    return _storage.remove(
      key,
    );
  }

  @override
  Future<String?> getValue(String key) async {
    return _storage.getString(
      key,
    );
  }

  @override
  Future<Map<String, dynamic>> readAll() async {
    final keys = _storage.getKeys();

    final Map<String, dynamic> values = {};

    for (final key in keys.toList()) {
      values[key] = _storage.getString(key);
    }

    return values;
  }

  @override
  Future<void> saveValue(String key, String value) {
    return _storage.setString(
      key,
      value,
    );
  }
}
