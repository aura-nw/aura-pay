import 'dart:convert';

import 'package:data/data.dart';
import 'package:flutter/services.dart';
import 'package:aurapay/src/core/constants/asset_path.dart';

final class LocalizationServiceImpl implements LocalizationService {
  String? _selectedLocale;
  @override
  Future<Map<String, String>> getLocalLanguage({required String locale}) async {
    String loader;
    try {
      loader = await rootBundle.loadString(
        AssetLanguagePath.localizationFullPath(locale),
      );
    } catch (e) {
      loader = await rootBundle
          .loadString(AssetLanguagePath.defaultLocalizationFullPath);
    }

    return Map<String, String>.from(jsonDecode(loader) as Map<String, dynamic>);
  }

  @override
  Future<List<String>> getSupportLocale() async {
    return [
      'vi',
      'en',
    ];
  }

  @override
  Future<String?> getSelectedLocale() {
    return Future.value(_selectedLocale);
  }

  @override
  void saveSelectedLocale({required String locale}) {
    _selectedLocale = locale;
  }
}
