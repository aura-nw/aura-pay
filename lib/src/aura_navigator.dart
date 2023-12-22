import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/app_routes.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_choice_option/on_boarding_choice_option_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_pick_account/on_boarding_pick_account_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_re_login/on_boarding_re_login_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_backup/on_boarding_recover_backup_address_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_backup_done/on_boarding_recover_backup_address_done_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_choice/on_boarding_recover_choice_screen.dart';
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
import 'package:pyxis_mobile/src/presentation/screens/settings/setting_passcode_and_biometric/change_passcode/change_passcode.dart';
import 'package:pyxis_mobile/src/presentation/screens/settings/setting_passcode_and_biometric/setting_passcode_and_biometric.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_new_sm_account_pick_account/signed_in_create_new_sm_account_pick_account_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_new_sm_account_scan_fee/signed_in_create_new_sm_account_scan_fee_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_import_key/signed_in_import_key_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_recover_choice/signed_in_recover_choice_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'presentation/screens/on_boarding_get_started/get_started_screen.dart';
import 'presentation/screens/on_boarding_import_key/on_boarding_import_key_screen.dart';
import 'presentation/screens/on_boarding_recover_select_account/on_boarding_recover_select_account_screen.dart';
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
  static const String recoverChoice = '$_onBoarding/recover_choice';
  static const String recoverSelectAccount =
      '$_onBoarding/recover_select_account';
  static const String recoverReviewing = '$_onBoarding/recover_reviewing';
  static const String recoverSign = '$_onBoarding/recover_sign';
  static const String recoverBackup = '$_onBoarding/recover_backup';
  static const String recoverBackupDone = '$_onBoarding/recover_backup_done';

  static const String home = '${_base}home';
  static const String sendTransaction = '$home/send_transaction';
  static const String sendTransactionConfirmation =
      '$home/send_transaction_confirmation';
  static const String sendTransactionSuccessFul =
      '$home/send_transaction_successful';
  static const String _signedInCreateNewAccount =
      '$home/signed_in_create_new_account';
  static const String signedInCreateNewAccountPickName =
      '$_signedInCreateNewAccount/pick_name';
  static const String signedInCreateNewAccountScanFee =
      '$_signedInCreateNewAccount/scan_fee';

  static const String _signedInRecover = '$home/signed_in_recover';
  static const String signedInRecoverChoice = '$_signedInRecover/choice';
  static const String signedInRecoverSelectAccount =
      '$_signedInRecover/select_account';
  static const String signedInRecoverSign = '$_signedInRecover/sign';

  static const String recoverMethod = '$home/recover_method';
  static const String setRecoverMethod = '$recoverMethod/set_recover_method';
  static const String recoverConfirmation = '$recoverMethod/confirmation';

  static const String _signedInImportAccount = '$home/signed_in_import_account';
  static const String signedInImportKey = '$_signedInImportAccount/import_key';

  static const String setting_page_passcode = '$_base/setting_page_passcode';

  static const String setting_change_passcode =
      '$_base/setting_change_passcode';
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
      case RoutePath.getStarted:
        return _defaultRoute(
          const OnBoardingGetStartedScreen(),
          settings,
        );
      case RoutePath.choiceOption:
        bool needToSetPassCode = settings.arguments as bool? ?? true;
        return _defaultRoute(
          OnBoardingChoiceOptionScreen(
            needToSetPassCode: needToSetPassCode,
          ),
          settings,
        );
      case RoutePath.setupPasscode:
        final OnboardingType type = settings.arguments as OnboardingType;
        return _defaultRoute(
          OnBoardingSetupPasscodeScreen(
            onboardingType: type,
          ),
          settings,
        );
      case RoutePath.setting_change_passcode:
        return _defaultRoute(
          const ChangePassCodePage(),
          settings,
        );
      case RoutePath.pickAccountName:
        return _defaultRoute(
          const OnBoardingPickAccountScreen(),
          settings,
        );
      case RoutePath.setting_page_passcode:
        return _defaultRoute(
          const SettingPagePasscode(),
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
          const OnBoardingImportKeyScreen(),
          settings,
        );
      case RoutePath.recoverChoice:
        return _defaultRoute(
          const OnBoardingRecoverChoiceScreen(),
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
        return _defaultRoute(
          const SendTransactionScreen(),
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
          const SignedInCreateNewSmAccountPickAccountScreen(),
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
          const SignedInImportKeyScreen(),
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
      case RoutePath.signedInRecoverChoice:
        return _defaultRoute(
          const SignedInRecoverChoiceScreen(),
          settings,
        );
      case RoutePath.recoverSign:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final AuraAccount account = arguments['account'];
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
        final AuraAccount account = arguments['account'];
        final GoogleAccount googleAccount = arguments['google_account'];
        return _defaultRoute(
          SignedInRecoverSignScreen(
            googleAccount: googleAccount,
            account: account,
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
      state?.pushNamedAndRemoveUntil(route, (route) => route.isFirst);

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
