const String _baseAsset = 'packages/pyxis_mobile/assets/';

sealed class AssetLogoPath{
  static const String _baseLogoPath = '${_baseAsset}logo/';
  static const String logo = '${_baseLogoPath}logo_pyxis.svg';
  static const String logoDark = '${_baseLogoPath}logo_pyxis_dark.svg';
}

sealed class AssetImagePath{
  static const String _baseImagePath = '${_baseAsset}image/';
  static const String onBoardingRecoverBackupAddress = '${_baseImagePath}img_on_boarding_recover_backup_address.svg';
}

sealed class AssetIconPath{
  static const String _baseIconPath = '${_baseAsset}icon/';

  ///onboarding
  static const String onBoardingCreateAccountSelected = '${_baseIconPath}ic_onboarding_create_account_selected.svg';
  static const String onBoardingImportKey = '${_baseIconPath}ic_onboarding_import_account.svg';
  static const String onBoardingRecoverAccount = '${_baseIconPath}ic_onboarding_recover_account.svg';
  static const String onBoardingActiveStep = '${_baseIconPath}ic_onboarding_active_step.svg';
  static const String onBoardingDisableStep = '${_baseIconPath}ic_onboarding_disable_step.svg';
  static const String onBoardingSuccessDisableStep = '${_baseIconPath}ic_onboarding_success_disable_step.svg';
  static const String onBoardingSuccessStep = '${_baseIconPath}ic_onboarding_success_step.svg';
  static const String onBoardingImportKeyCheck= '${_baseIconPath}ic_onboarding_import_account_check.svg';
  static const String onBoardingImportKeyInformation = '${_baseIconPath}ic_onboarding_import_account_information.svg';
  static const String onBoardingRecoverChoiceGoogle = '${_baseIconPath}ic_onboarding_recover_choice_google.svg';
  static const String onBoardingRecoverChoiceBackupAddress = '${_baseIconPath}ic_onboarding_recover_choice_backup_address.svg';

  ///common
  static const String commonCopy = '${_baseIconPath}ic_common_copy.svg';
  static const String commonCopyActive = '${_baseIconPath}ic_common_copy_active.svg';
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
  static const String commonRadioActive = '${_baseIconPath}ic_common_radio_active.svg';
  static const String commonRadioCheck = '${_baseIconPath}ic_common_radio_check.svg';
  static const String commonClose = '${_baseIconPath}ic_common_close.svg';
  static const String commonInputError = '${_baseIconPath}ic_common_input_error.svg';

  /// Home page
  static const String homeNoTokenFound = '${_baseIconPath}ic_home_no_token_found.svg';
  static const String homeSendToken= '${_baseIconPath}ic_home_send_token.svg';
  static const String homeReceiveToken= '${_baseIconPath}ic_home_receive_token.svg';
  static const String homeStake= '${_baseIconPath}ic_home_stake.svg';
  static const String homeTxLimit= '${_baseIconPath}ic_home_tx_limit.svg';
  static const String homeNFTs= '${_baseIconPath}ic_home_nfts.svg';
}