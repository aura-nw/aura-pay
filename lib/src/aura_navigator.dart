import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/core/app_routes.dart';
import 'package:pyxis_mobile/src/presentation/screens/accounts/accounts_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/backup_private_key/backup_privatekey_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser/browser_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser_search/browser_search_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser_tab_management/browser_tab_management_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/connect_site/connect_site_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/connect_wallet/connect_wallet_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/controller_key_management/controller_key_management_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft_detail/nft_detail_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_choice_option/on_boarding_choice_option_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_confirm_recover_phrase/on_boarding_confirm_recover_phrase_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_create_eoa/on_boarding_create_eoa_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_create_eoa_by_google_pick_name/on_boarding_create_eoa_by_google_pick_name_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_pick_account/on_boarding_pick_account_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_re_login/on_boarding_re_login_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_backup/on_boarding_recover_backup_address_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_backup_done/on_boarding_recover_backup_address_done_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_request_reviewing/on_boarding_recover_request_reviewing_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_sign/on_boarding_recover_sign_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_scan_fee/on_boarding_scan_fee_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_setup_passcode/on_boarding_setup_passcode_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method/recovery_method_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method_confirmation/recovery_method_confirmation_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/scanner/scanner_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction/send_transaction_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction_confirmation/send_transaction_confirmation_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction_result/send_transaction_result_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/set_recovery_method/set_recovery_method_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/setting_change_passcode/setting_change_passcode_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/setting_passcode_and_biometric/setting_passcode_and_biometric_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_choice_option/signed_in_choice_option_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_confirm_recover_phrase/signed_in_confirm_recover_phrase_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_eoa/signed_in_create_eoa_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_eoa_by_google/signed_in_create_eoa_by_google_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_new_sm_account_scan_fee/signed_in_create_new_sm_account_scan_fee_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_import_normal_wallet_key/signed_in_import_normal_wallet_key_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_pick_account/signed_in_pick_account_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_verify_pass_code/signed_in_verify_pass_code_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/on_boarding_create_eoa_by_google/on_boarding_create_eoa_by_google_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/wallet_connect_screen/wallet_connect_sign_transaction/confirm_transaction_screen.dart';
import 'presentation/screens/on_boarding_get_started/get_started_screen.dart';
import 'presentation/screens/on_boarding_import_normal_wallet_key/on_boarding_import_normal_wallet_key_screen.dart';
import 'presentation/screens/on_boarding_recover_phrase/on_boarding_recover_phrase_screen.dart';
import 'presentation/screens/on_boarding_recover_select_account/on_boarding_recover_select_account_screen.dart';
import 'presentation/screens/signed_in_create_eoa_by_google_pick_name/signed_in_create_eoa_by_google_pick_name_screen.dart';
import 'presentation/screens/signed_in_recover_select_account/singed_in_recover_select_account_screen.dart';
import 'presentation/screens/signed_in_recover_sign/signed_in_recover_sign_screen.dart';

sealed class RoutePath {
  static const String _base = '/';
  static const String splash = _base;
  static const String scanner = '${_base}scanner';
  static const String _onBoarding = '${_base}onboarding';
  static const String reLogin = '$_onBoarding/re_login';
  static const String getStarted = '$_onBoarding/get_started';
  static const String choiceOption = '$_onBoarding/choice_option';
  static const String setupPasscode = '$_onBoarding/setup_passcode';
  static const String pickAccountName = '$_onBoarding/pick_account_name';
  static const String scanQrFee = '$_onBoarding/scan_qr_fee';
  static const String importFirstPage = '$_onBoarding/import_first_page';
  static const String recoverSelectAccount =
      '$_onBoarding/recover_select_account';
  static const String recoverReviewing = '$_onBoarding/recover_reviewing';
  static const String recoverSign = '$_onBoarding/recover_sign';
  static const String recoverBackup = '$_onBoarding/recover_backup';
  static const String recoverBackupDone = '$_onBoarding/recover_backup_done';
  static const String createNewWallet = '$_onBoarding/create_new_normal_wallet';
  static const String createNewWalletBackupPhrase =
      '$createNewWallet/back_up_phrase';
  static const String createNewWalletConfirmPhrase =
      '$createNewWallet/confirm_phrase';

  static const String createNewWalletByGoogle =
      '$_onBoarding/create_new_normal_wallet_by_google';
  static const String createNewWalletByGooglePickName =
      '$createNewWalletByGoogle/pick_name';

  static const String home = '${_base}home';
  static const String nft = '$home/nft';
  static const String nftDetail = '$home/nft_detail';
  static const String sendTransaction = '$home/send_transaction';
  static const String sendTransactionConfirmation =
      '$home/send_transaction_confirmation';
  static const String sendTransactionSuccessFul =
      '$home/send_transaction_successful';
  static const String _signedInOnBoarding = '$accounts/signed_in_onboarding/';
  static const String signedInCreateNewAccountPickName =
      '$_signedInOnBoarding/pick_name';
  static const String signedInCreateNewAccountScanFee =
      '$_signedInOnBoarding/scan_fee';

  static const String signedInChoiceOption =
      '$_signedInOnBoarding/choice_option';
  static const String signedInCreateNewWallet =
      '$_signedInOnBoarding/create_new_normal_wallet';

  static const String signedInCreateNewWalletBackupPhrase =
      '$signedInCreateNewWallet/create_normal_wallet_back_up_phrase';

  static const String signedInRecoverSelectAccount =
      '$_signedInOnBoarding/select_account';
  static const String signedInRecoverSign =
      '$signedInRecoverSelectAccount/sign';

  static const String signedInImportKey =
      '$_signedInOnBoarding/import_normal_wallet';

  static const String signedInCreateNormalWalletByGoogle =
      '$_signedInOnBoarding/create_normal_wallet_by_google';

  static const String signedInCreateNewWalletByGooglePickName =
      '$signedInCreateNormalWalletByGoogle/pick_name';

  static const String recoverMethod = '$home/recover_method';
  static const String setRecoverMethod = '$recoverMethod/set_recover_method';
  static const String recoverConfirmation = '$recoverMethod/confirmation';

  static const String _setting = '$_base/setting';

  static const String settingPassCodeAndBioMetric =
      '$_setting/setting_change_passcode_and_biometric';

  static const String settingChangePassCode =
      '$settingPassCodeAndBioMetric/change_passcode';

  static const String settingConnectSite = '$_setting/connect_site';

  static const String walletConnect = '$home/wallet_connect';
  static const String walletConnectOnConnect =
      '$home/wallet_connect/on_connect';
  static const String walletConnectConfirmTransaction =
      '$home/wallet_connect/on_confirm_transaction';

  static const String controllerKeyManagement =
      '$home/controller_key_management';

  static const String browser = '$home/browser';
  static const String browserSearch = '$home/search';
  static const String browserTabManagement = '$home/tab_management';
  static const String accounts = '$home/account';

  static const String backUpPrivateKey = '$home/backup_private_key';

  static const String signedInVerifyPasscode =
      '$home/signed_in_verify_passcode';
}

sealed class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return _defaultRoute(
          const SplashScreen(),
          settings,
        );
      case RoutePath.reLogin:
        return _defaultRoute(
          const OnBoardingReLoginScreen(),
          settings,
        );
      case RoutePath.walletConnectOnConnect:
        final ConnectingData data = settings.arguments as ConnectingData;
        return _defaultRoute(
          ConnectWalletScreen(
            connectingData: data,
          ),
          settings,
        );
      case RoutePath.walletConnectConfirmTransaction:
        final RequestSessionData data =
            settings.arguments as RequestSessionData;
        return _defaultRoute(
          WalletConnectConfirmTransactionScreen(
            sessionData: data,
          ),
          settings,
        );

      case RoutePath.getStarted:
        return _defaultRoute(
          const OnBoardingGetStartedScreen(),
          settings,
        );
      case RoutePath.choiceOption:
        return _defaultRoute(
          const OnBoardingChoiceOptionScreen(),
          settings,
        );
      case RoutePath.setupPasscode:
        return _defaultRoute(
          const OnBoardingSetupPasscodeScreen(),
          settings,
        );
      case RoutePath.settingPassCodeAndBioMetric:
        return _defaultRoute(
          const SettingPasscodeAndBiometricScreen(),
          settings,
        );
      case RoutePath.settingChangePassCode:
        return _defaultRoute(
          const SettingChangePasscodeScreen(),
          settings,
        );
      case RoutePath.pickAccountName:
        return _defaultRoute(
          const OnBoardingPickAccountScreen(),
          settings,
        );
      case RoutePath.scanQrFee:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final String rawAddress = arguments['smart_account_address'];
        final String accountName = arguments['accountName'];
        final Uint8List privateKey = arguments['privateKey'];
        final Uint8List salt = arguments['salt'];
        return _defaultRoute(
          OnBoardingScanFeeScreen(
            rawAddress: rawAddress,
            accountName: accountName,
            privateKey: privateKey,
            salt: salt,
          ),
          settings,
        );
      case RoutePath.importFirstPage:
        return _defaultRoute(
          const OnBoardingImportNormalWalletKeyScreen(),
          settings,
        );
      case RoutePath.recoverSelectAccount:
        final GoogleAccount googleAccount = settings.arguments as GoogleAccount;
        return _defaultRoute(
          OnBoardingRecoverSelectAccountScreen(
            googleAccount: googleAccount,
          ),
          settings,
        );
      case RoutePath.recoverReviewing:
        return _defaultRoute(
          const OnBoardingRecoverRequestReviewingScreen(),
          settings,
        );
      case RoutePath.recoverBackup:
        return _defaultRoute(
          const OnBoardingRecoverBackupAddressScreen(),
          settings,
        );
      case RoutePath.recoverBackupDone:
        return _defaultRoute(
          const OnBoardingRecoverBackupDoneAddressScreen(),
          settings,
        );
      case RoutePath.home:
        return _defaultRoute(
          const HomeScreen(),
          settings,
        );
      case RoutePath.sendTransaction:
        final String? initRecipientAddress = settings.arguments as String?;
        return _defaultRoute(
          SendTransactionScreen(
            initAddress: initRecipientAddress,
          ),
          settings,
        );
      case RoutePath.sendTransactionConfirmation:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;

        final String amount = arguments['amount'] as String;
        final String recipient = arguments['recipient'] as String;
        final AuraAccount sender = arguments['sender'];
        final String transactionFee = arguments['transactionFee'] as String;
        final int gasEstimation = arguments['gasEstimation'] as int;

        return _defaultRoute(
          SendTransactionConfirmationScreen(
            amount: amount,
            recipient: recipient,
            sender: sender,
            transactionFee: transactionFee,
            gasEstimation: gasEstimation,
          ),
          settings,
        );
      case RoutePath.sendTransactionSuccessFul:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;

        final String amount = arguments['amount'] as String;
        final String recipient = arguments['recipient'] as String;
        final String sender = arguments['sender'] as String;
        final String hash = arguments['hash'] as String;
        final String time = arguments['time'] as String;

        return _defaultRoute(
          SendTransactionResultScreen(
            amount: amount,
            recipient: recipient,
            sender: sender,
            txHash: hash,
            timeCreated: time,
          ),
          settings,
        );
      case RoutePath.signedInCreateNewAccountPickName:
        return _defaultRoute(
          const SignedInPickAccountScreen(),
          settings,
        );
      case RoutePath.signedInCreateNewAccountScanFee:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final String rawAddress = arguments['smart_account_address'];
        final String accountName = arguments['accountName'];
        final Uint8List privateKey = arguments['privateKey'];
        final Uint8List salt = arguments['salt'];
        return _defaultRoute(
          SignedInCreateNewSmAccountScanFeeScreen(
            rawAddress: rawAddress,
            accountName: accountName,
            privateKey: privateKey,
            salt: salt,
          ),
          settings,
        );

      case RoutePath.signedInImportKey:
        return _defaultRoute(
          const SignedInImportNormalWalletKeyScreen(),
          settings,
        );
      case RoutePath.scanner:
        return _defaultRoute(
          const ScannerScreen(),
          settings,
        );
      case RoutePath.recoverMethod:
        return _defaultRoute(
          const RecoveryMethodScreen(),
          settings,
        );
      case RoutePath.setRecoverMethod:
        final AuraAccount account = settings.arguments as AuraAccount;
        return _defaultRoute(
          SetRecoveryMethodScreen(
            account: account,
          ),
          settings,
        );
      case RoutePath.recoverConfirmation:
        final RecoveryMethodConfirmationArgument argument =
            settings.arguments as RecoveryMethodConfirmationArgument;
        return _defaultRoute(
          RecoveryMethodConfirmationScreen(
            argument: argument,
          ),
          settings,
        );
      case RoutePath.recoverSign:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final PyxisRecoveryAccount account = arguments['account'];
        final GoogleAccount googleAccount = arguments['google_account'];
        return _defaultRoute(
          OnBoardingRecoverSignScreen(
              googleAccount: googleAccount, account: account),
          settings,
        );
      case RoutePath.signedInRecoverSelectAccount:
        final GoogleAccount googleAccount = settings.arguments as GoogleAccount;
        return _defaultRoute(
          SingedInRecoverSelectAccountScreen(
            googleAccount: googleAccount,
          ),
          settings,
        );
      case RoutePath.signedInRecoverSign:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final PyxisRecoveryAccount account = arguments['account'];
        final GoogleAccount googleAccount = arguments['google_account'];
        return _defaultRoute(
          SignedInRecoverSignScreen(
            googleAccount: googleAccount,
            account: account,
          ),
          settings,
        );
      case RoutePath.nft:
        return _defaultRoute(
          const NFTScreen(),
          settings,
        );
      case RoutePath.nftDetail:
        final NFTInformation nftInformation =
            settings.arguments as NFTInformation;
        return _defaultRoute(
          NFTDetailScreen(
            nftInformation: nftInformation,
          ),
          settings,
        );
      case RoutePath.settingConnectSite:
        return _defaultRoute(
          const ConnectSiteScreen(),
          settings,
        );
      case RoutePath.browser:
        final String initUrl = settings.arguments as String;
        return _defaultRoute(
          BrowserScreen(
            initUrl: initUrl,
          ),
          settings,
        );
      case RoutePath.accounts:
        final HomeScreenBloc homeScreenBloc =
            settings.arguments as HomeScreenBloc;
        return _defaultRoute(
          AccountsScreen(
            homeScreenBloc: homeScreenBloc,
          ),
          settings,
        );
      case RoutePath.browserSearch:
        return _defaultRoute(
          const BrowserSearchScreen(),
          settings,
        );
      case RoutePath.browserTabManagement:
        final bool closeAndReplace = settings.arguments as bool? ?? true;
        return _defaultRoute(
          BrowserTabManagementScreen(
            isCloseAndReplace: closeAndReplace,
          ),
          settings,
        );
      case RoutePath.createNewWallet:
        return _defaultRoute(
          const OnBoardingCreateEOAScreen(),
          settings,
        );
      case RoutePath.createNewWalletBackupPhrase:
        final PyxisWallet pyxisWallet = settings.arguments as PyxisWallet;
        return _defaultRoute(
          OnBoardingRecoverPhraseScreen(
            pyxisWallet: pyxisWallet,
          ),
          settings,
        );
      case RoutePath.createNewWalletConfirmPhrase:
        final PyxisWallet pyxisWallet = settings.arguments as PyxisWallet;
        return _defaultRoute(
          OnBoardingConfirmRecoveryPhraseScreen(
            pyxisWallet: pyxisWallet,
          ),
          settings,
        );
      case RoutePath.createNewWalletByGoogle:
        return _defaultRoute(
          const OnBoardingCreateEOAByGoogleScreen(),
          settings,
        );
      case RoutePath.createNewWalletByGooglePickName:
        return _defaultRoute(
          const OnBoardingCreateEOAByGooglePickNameScreen(),
          settings,
        );
      case RoutePath.backUpPrivateKey:
        final String address = settings.arguments as String;
        return _defaultRoute(
          BackupPrivateKeyScreen(
            address: address,
          ),
          settings,
        );
      case RoutePath.signedInChoiceOption:
        return _defaultRoute(
          const SignedInChoiceOptionScreen(),
          settings,
        );
      case RoutePath.signedInCreateNewWallet:
        return _defaultRoute(
          const SignedInCreateEOAScreen(),
          settings,
        );
      case RoutePath.signedInCreateNormalWalletByGoogle:
        return _defaultRoute(
          const SignedInCreateEOAByGoogleScreen(),
          settings,
        );
      case RoutePath.signedInCreateNewWalletBackupPhrase:
        final PyxisWallet pyxisWallet = settings.arguments as PyxisWallet;
        return _defaultRoute(
          SignedInConfirmRecoveryPhraseScreen(
            pyxisWallet: pyxisWallet,
          ),
          settings,
        );

      case RoutePath.signedInCreateNewWalletByGooglePickName:
        return _defaultRoute(
          const SignedInCreateEOAByGooglePickNameScreen(),
          settings,
        );

      case RoutePath.controllerKeyManagement:
        return _defaultRoute(
          const ControllerKeyManagementScreen(),
          settings,
        );
      case RoutePath.signedInVerifyPasscode:
        final VoidCallback onVerifySuccessful =
            settings.arguments as VoidCallback;
        return _defaultRoute(
          SignedInVerifyPasscodeScreen(
            onVerifySuccessful: onVerifySuccessful,
          ),
          settings,
        );
      default:
        return _defaultRoute(
          const SplashScreen(),
          settings,
        );
    }
  }

  static Future? push<T>(String route, [T? arguments]) =>
      state?.pushNamed(route, arguments: arguments);

  static Future? replaceWith<T>(String route, [T? arguments]) =>
      state?.pushReplacementNamed(route, arguments: arguments);

  static void pop<T>([T? arguments]) => state?.pop(arguments);

  static void popUntil(String routeName) => state?.popUntil(
        (route) => route.settings.name == routeName,
      );

  static void popToFirst() => state?.popUntil((route) => route.isFirst);

  static void replaceAllWith(String route) =>
      state?.pushNamedAndRemoveUntil(route, (route) => false);

  static NavigatorState? get state => navigatorKey.currentState;

  static Route _defaultRoute(
    Widget child,
    RouteSettings settings,
  ) {
    return SlideRoute(
      page: child,
      settings: settings,
    );
  }
}
