import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/domain/repository/localization_repository.dart';

final class LocalizationRepositoryImpl implements LocalizationRepository {
  @override
  Future<Map<String, String>> getLocalLanguage({required String locale}) async {
    String loader;
    try {
      loader = await rootBundle.loadString(
        LocalizationPath.localizationFullPath(locale),
      );
    } catch (e) {
      loader = await rootBundle
          .loadString(LocalizationPath.defaultLocalizationFullPath);
    }

    return Map<String, String>.from(jsonDecode(loader) as Map<String, dynamic>);
  }

  @override
  Future<Map<String, String>> getRemoteLanguage({
    required String locale,
  }) async {
    throw UnimplementedError('getRemoteLanguage() don\'t be supported');
  }

  @override
  Future<List<String>> getSupportLocale() async {
    return [
      'vi',
      'en',
    ];
  }
}
