const String _baseAsset = 'packages/pyxis_mobile/assets/';

final class AssetLogoPath{
  static const String _baseImagePath = '${_baseAsset}logo/';
  static const String logo = '${_baseImagePath}logo_pyxis.svg';
  static const String logoWithName = '${_baseImagePath}logo_pyxis_with_name.svg';
  static const String logoTransparent = '${_baseImagePath}logo_pyxis_transparent.svg';
  static const String logoTransparentWithName = '${_baseImagePath}logo_pyxis_transparent_with_name.svg';
}

final class AssetIconPath{
  static const String _baseIconPath = '${_baseAsset}icon/';

  ///onboarding
  static const String onBoardingCreateAccountSelected = '${_baseIconPath}ic_onboarding_create_account_selected.svg';
  static const String onBoardingImportAccount = '${_baseIconPath}ic_onboarding_import_account.svg';
  static const String onBoardingRecoverAccount = '${_baseIconPath}ic_onboarding_recover_account.svg';
  static const String onBoardingActiveStep = '${_baseIconPath}ic_onboarding_active_step.svg';
  static const String onBoardingDisableStep = '${_baseIconPath}ic_onboarding_disable_step.svg';
  static const String onBoardingSuccessDisableStep = '${_baseIconPath}ic_onboarding_success_disable_step.svg';
  static const String onBoardingSuccessStep = '${_baseIconPath}ic_onboarding_success_step.svg';
  static const String onBoardingImportAccountCheck= '${_baseIconPath}ic_onboarding_import_account_check.svg';
  static const String onBoardingImportAccountInformation = '${_baseIconPath}ic_onboarding_import_account_information.svg';

  ///common
  static const String commonCopy = '${_baseIconPath}ic_common_copy.svg';
  static const String commonArrowBack = '${_baseIconPath}ic_common_arrow_back.svg';
  static const String commonClear = '${_baseIconPath}ic_common_clear.svg';
  static const String commonInformation = '${_baseIconPath}ic_common_information.svg';
  static const String commonLogoSmall = '${_baseIconPath}ic_common_logo_small.svg';
  static const String commonLogo = '${_baseIconPath}ic_common_logo.svg';
  static const String commonWarning = '${_baseIconPath}ic_common_dialog_warning.svg';
  static const String commonArrowDown = '${_baseIconPath}ic_common_arrow_down.svg';
  static const String commonEyeActive = '${_baseIconPath}ic_common_eye_active.svg';
  static const String commonEyeHide = '${_baseIconPath}ic_common_eye_hide.svg';
  static const String commonRadioUnCheck = '${_baseIconPath}ic_common_radio_uncheck.svg';
  static const String commonRadioCheck = '${_baseIconPath}ic_common_radio_check.svg';
  static const String commonClose = '${_baseIconPath}ic_common_close.svg';
  static const String commonInputError = '${_baseIconPath}ic_common_input_error.svg';
}

final class LocalizationPath{
  static const String _baseLocalizationPath = '${_baseAsset}language/';

  static String localizationFullPath(String locale){
    return '$_baseLocalizationPath$locale.json';
  }

  static String defaultLocalizationFullPath = localizationFullPath('vi');
}