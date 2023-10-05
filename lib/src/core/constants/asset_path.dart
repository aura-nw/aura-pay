const String _baseAsset = 'packages/pyxis_mobile/assets/';

final class AssetLogoPath{
  static const String _baseImagePath = '${_baseAsset}logo/';
  static const String logo = '${_baseImagePath}logo_pyxis.svg';
  static const String logoTransparent = '${_baseImagePath}logo_pyxis_transparent.svg';
}

final class AssetIconPath{
  static const String _baseIconPath = '${_baseAsset}icon/';
  static const String onBoardingCreateAccountSelected = '${_baseIconPath}ic_onboarding_create_account_selected.svg';
  static const String onBoardingImportAccount = '${_baseIconPath}ic_onboarding_import_account.svg';
  static const String onBoardingRecoverAccount = '${_baseIconPath}ic_onboarding_recover_account.svg';
}

final class LocalizationPath{
  static const String _baseLocalizationPath = '${_baseAsset}language/';

  static String localizationFullPath(String locale){
    return '$_baseLocalizationPath$locale.json';
  }

  static String defaultLocalizationFullPath = localizationFullPath('vi');
}