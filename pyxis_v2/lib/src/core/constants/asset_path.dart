const String _baseAsset = 'assets/';

sealed class AssetLanguagePath{
  static const String _languagePath = '${_baseAsset}language/';

  static String localizationFullPath(String locale){
    return '$_languagePath$locale.json';
  }

  static String defaultLocalizationFullPath = localizationFullPath('vi');
}

sealed class AssetConfigPath{
  static const String config = '${_baseAsset}config/config.json';
}

sealed class AssetLogoPath {
  static const String _baseLogoPath = '${_baseAsset}logo/';
  static const String logo = '${_baseLogoPath}logo.svg';
}

sealed class AssetImagePath {
  static const String _baseImgPath = '${_baseAsset}image/';

  static const String yetiBot = '${_baseImgPath}img_yeti_bot.svg';
}

sealed class AssetIconPath {
  static const String _baseIconPath = '${_baseAsset}icon/';

  static const String icCommonArrowBack = '${_baseIconPath}ic_common_arrow_back.svg';
  static const String icCommonClear = '${_baseIconPath}ic_common_clear.svg';
  static const String icCommonYetiHand = '${_baseIconPath}ic_common_yeti_hand.svg';
  static const String icCommonInputError = '${_baseIconPath}ic_common_input_error.svg';
  static const String icCommonClose = '${_baseIconPath}ic_common_close.svg';
  static const String icCommonPaste = '${_baseIconPath}ic_common_paste.svg';
  static const String icCommonCopy = '${_baseIconPath}ic_common_copy.svg';
  static const String icCommonCheckSuccess = '${_baseIconPath}ic_common_check_success.svg';
  static const String icCommonGoogle = '${_baseIconPath}ic_common_google.svg';
  static const String icCommonTwitter = '${_baseIconPath}ic_common_twitter.svg';
  static const String icCommonApple = '${_baseIconPath}ic_common_apple.svg';
}
