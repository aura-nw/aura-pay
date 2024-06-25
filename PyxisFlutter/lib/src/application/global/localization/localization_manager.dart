import 'dart:async';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pyxis_mobile/app_configs/di.dart';

class AppLocalizationManager {
  final LocalizationUseCase _localizationUseCase =
      getIt.get<LocalizationUseCase>();

  ///region create instance
  /// Create lazy singleton -- instance of [AppLocalizationManager]
  static AppLocalizationManager? _appLocalizationManager;

  AppLocalizationManager._init();

  factory AppLocalizationManager() {
    _appLocalizationManager ??= AppLocalizationManager._init();

    return _appLocalizationManager!;
  }

  static AppLocalizationManager get instance => AppLocalizationManager();

  static AppLocalizationManager of(BuildContext context) => Localizations.of(context, AppLocalizationManager);

  ///endregion

  ///region localization map
  final Map<String, Map<String, String>> _localize = {};

  Locale _locale = const Locale('vi');

  Map<String, String> get _currentLocalize =>
      _localize[_locale.languageCode] ?? <String, String>{};

  ///endregion

  Locale getAppLocale() {
    return _locale;
  }

  bool isSupportLocale(Locale locale) {
    return _localize.containsKey(locale.languageCode);
  }

  void setCurrentLocale(Locale locale) {
    if (isSupportLocale(locale)) {
      _locale = locale;
    }
  }

  List<String> get supportedLang =>
      _localize.entries.map((e) => e.key).toList();

  Future<void> load() async {
    ///Get instance locale from storage - just fake
    String storageLocale = 'vi';

    ///Get support locale
    try {
      final List<String> supportLocales =
          await _localizationUseCase.getSupportLocale();

      if (supportLocales.contains(storageLocale)) {
        setCurrentLocale(Locale(storageLocale));
      } else {
        _initLocale();
      }
    } catch (e) {
      _initLocale();
    }

    ///Get language from locale
    _localize[_locale.languageCode] =
        await _localizationUseCase.getLocalLanguage(
      locale: _locale.languageCode,
    );
  }

  ///set lang from server
  // void loadFromJson(Map<String, Map<String, String>> json) {
  //   json.forEach((key, value) {
  //     if (_localize[key.toLowerCase()] != null) {
  //       _localize[key.toLowerCase()]!.addAll(value);
  //     } else {
  //       _localize[key.toLowerCase()] = value;
  //     }
  //   });
  // }

  void _initLocale() {
    String localeName = Platform.localeName;

    Locale deviceLocale;

    if (localeName.toLowerCase() == 'vi' ||
        localeName.toLowerCase() == 'vi_vn') {
      deviceLocale = const Locale('vi');
    } else {
      deviceLocale = const Locale('en');
    }

    if (isSupportLocale(deviceLocale)) {
      _locale = deviceLocale;
    } else {
      _locale = const Locale('en');
    }
  }

  ///region translate
  String translate(String key) {
    return _currentLocalize[key] ?? key;
  }

  String translateWithParam(String key, Map<String, dynamic> param) {
    if (_currentLocalize[key] != null) {
      String currentValue = _currentLocalize[key]!;

      param.forEach((paramKey, paramValue) {
        currentValue = currentValue.replaceFirst(
          '\${$paramKey}',
          paramValue.toString(),
        );
      });
      return currentValue;
    }

    return key;
  }

  ///endregion fu
}
