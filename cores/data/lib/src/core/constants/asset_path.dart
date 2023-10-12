const String _baseAsset = 'packages/pyxis_mobile/assets/';

sealed class LocalizationPath{
  static const String _baseLocalizationPath = '${_baseAsset}language/';

  static String localizationFullPath(String locale){
    return '$_baseLocalizationPath$locale.json';
  }

  static String defaultLocalizationFullPath = localizationFullPath('vi');
}