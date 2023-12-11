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
  static const String commonCheckSuccess = '${_baseIconPath}ic_common_check_success.svg';
  static const String commonSmartAccountAvatarDefault= '${_baseIconPath}ic_common_smart_account_avatar_default.svg';
  static const String commonCloseBottomSheet = '${_baseIconPath}ic_common_close_bottom_sheet.svg';
  static const String commonPermissionCamera = '${_baseIconPath}ic_common_permission_camera.svg';
  static const String commonPermissionGallery = '${_baseIconPath}ic_common_permission_gallery.svg';

  /// Home screen
  static const String homeBottomNavigatorBarHomeActive = '${_baseIconPath}ic_home_bottom_navigator_bar_home_active.svg';
  static const String homeBottomNavigatorBarHome = '${_baseIconPath}ic_home_bottom_navigator_bar_home.svg';
  static const String homeBottomNavigatorBarAccount = '${_baseIconPath}ic_home_bottom_navigator_bar_account.svg';
  static const String homeBottomNavigatorBarAccountActive = '${_baseIconPath}ic_home_bottom_navigator_bar_account_active.svg';
  static const String homeBottomNavigatorBarHistory = '${_baseIconPath}ic_home_bottom_navigator_bar_history.svg';
  static const String homeBottomNavigatorBarHistoryActive = '${_baseIconPath}ic_home_bottom_navigator_bar_history_active.svg';
  static const String homeBottomNavigatorBarScan = '${_baseIconPath}ic_home_bottom_navigator_bar_scan.svg';
  static const String homeBottomNavigatorBarSetting = '${_baseIconPath}ic_home_bottom_navigator_bar_setting.svg';
  static const String homeBottomNavigatorBarSettingActive = '${_baseIconPath}ic_home_bottom_navigator_bar_setting_active.svg';

  /// Home page
  static const String homeNoTokenFound = '${_baseIconPath}ic_home_no_token_found.svg';
  static const String homeSendToken= '${_baseIconPath}ic_home_send_token.svg';
  static const String homeReceiveToken= '${_baseIconPath}ic_home_receive_token.svg';
  static const String homeStake= '${_baseIconPath}ic_home_stake.svg';
  static const String homeTxLimit= '${_baseIconPath}ic_home_tx_limit.svg';
  static const String homeNFTs= '${_baseIconPath}ic_home_nfts.svg';
  static const String homeAppBar= '${_baseIconPath}ic_home_nfts.svg';
  static const String homeAppBarLogo= '${_baseIconPath}ic_home_app_bar_logo.svg';
  static const String homeAppBarNotification= '${_baseIconPath}ic_home_app_bar_notification.svg';
  static const String homeCopy= '${_baseIconPath}ic_home_copy.svg';
  static const String homeArrowDown= '${_baseIconPath}ic_home_arrow_down.svg';
  static const String homeReceiveShareAddress= '${_baseIconPath}ic_home_receive_share_address.svg';
  static const String homeReceiveCopyAddress= '${_baseIconPath}ic_home_receive_copy_address.svg';

  ///Accounts page
  static const String accountsMore = '${_baseIconPath}ic_accounts_more.svg';
  static const String accountsCheck = '${_baseIconPath}ic_accounts_check.svg';
  static const String accountsRemove = '${_baseIconPath}ic_accounts_remove.svg';
  static const String accountsRemoveWarning = '${_baseIconPath}ic_accounts_remove_warning.svg';
  static const String accountsRename = '${_baseIconPath}ic_accounts_rename.svg';
  static const String accountsShare = '${_baseIconPath}ic_accounts_share.svg';
  static const String accountsRecoverSmartAccount = '${_baseIconPath}ic_accounts_recover_smart_account.svg';
  static const String accountsImportExistingAccount = '${_baseIconPath}ic_accounts_import_existing_account.svg';
  static const String accountsCreateNewSmartAccount = '${_baseIconPath}ic_accounts_create_new_smart_account.svg';
  static const String accountsViewOnAuraScan = '${_baseIconPath}ic_account_view_on_aura_scan.svg';


  ///signed in import account
  static const String signedInImportKeyInformation = '${_baseIconPath}ic_signed_in_import_account_information.svg';


  ///Send transaction
  static const String sendQr = '${_baseIconPath}ic_send_qr.svg';
  static const String sendAuraCoin = '${_baseIconPath}ic_send_aura_coin.svg';


  /// Send transaction confirmation
  static const String sendConfirmation = '${_baseIconPath}ic_send_confirmation.svg';
  static const String sendConfirmationEdit = '${_baseIconPath}ic_send_confirmation_edit.svg';
  static const String sendConfirmationMessage = '${_baseIconPath}ic_send_confirmation_message.svg';
  static const String sendConfirmationDivider = '${_baseIconPath}ic_send_confirmation_divider.svg';

  /// Send transaction successful
  static const String sendSuccessfulLogo = '${_baseIconPath}ic_transaction_successful_logo.svg';
  static const String sendSuccessfulCopy = '${_baseIconPath}ic_transaction_successful_copy.svg';
  static const String sendSuccessfulView = '${_baseIconPath}ic_transaction_successful_view.svg';

  /// Scanner
  static const String scannerBack = '${_baseIconPath}ic_scanner_back.svg';
  static const String scannerPhoto = '${_baseIconPath}ic_scanner_photo.svg';
}