const String _baseAsset = 'packages/aura_wallet/assets/';

final class AssetImagePath{
  static const String _baseImagePath = '${_baseAsset}image/';
  static const String logo = '${_baseImagePath}aura_logo.png';
}

final class AssetIconKey{
  static const String _baseIconPath = '${_baseAsset}icon/';
}

final class LocalizationPath{
  static const String _baseLocalizationPath = '${_baseAsset}language/';

  static String localizationFullPath(String locale){
    return '$_baseLocalizationPath$locale.json';
  }

  static String defaultLocalizationFullPath = localizationFullPath('vi');
}