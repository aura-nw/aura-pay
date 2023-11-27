import 'dart:typed_data';

import 'package:pyxis_mobile/src/core/app_routes.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_choice_option/on_boarding_choice_option_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_pick_account/on_boarding_pick_account_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_backup/on_boarding_recover_backup_address_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_backup_done/on_boarding_recover_backup_address_done_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_choice/on_boarding_recover_choice_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_request_reviewing/on_boarding_recover_request_reviewing_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_scan_fee/on_boarding_scan_fee_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_setup_passcode/on_boarding_setup_passcode_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'presentation/screens/on_boarding_get_started/get_started_screen.dart';
import 'presentation/screens/on_boarding_import_key/on_boarding_import_key_screen.dart';
import 'presentation/screens/on_boarding_recover_select_account/on_boarding_recover_select_account_screen.dart';

sealed class RoutePath {
  static const String _base = '/';
  static const String splash = _base;
  static const String _onBoarding = '${_base}onboarding';
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
  static const String recoverBackup = '$_onBoarding/recover_backup';
  static const String recoverBackupDone = '$_onBoarding/recover_backup_done';

  static const String home = '${_base}home';
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
      case RoutePath.getStarted:
        return _defaultRoute(
          const OnBoardingGetStartedScreen(),
          settings,
        );
      case RoutePath.choiceOption:
        return _defaultRoute(
          OnBoardingChoiceOptionScreen(),
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
      case RoutePath.pickAccountName:
        final String passWord = settings.arguments as String;
        return _defaultRoute(
          OnBoardingPickAccountScreen(
            passWord: passWord,
          ),
          settings,
        );
      case RoutePath.scanQrFee:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final String rawAddress = arguments['smart_account_address'];
        final Uint8List privateKey = arguments['privateKey'];
        final Uint8List salt = arguments['salt'];
        return _defaultRoute(
          OnBoardingScanFeeScreen(
            rawAddress: rawAddress,
            privateKey: privateKey,
            salt: salt,
          ),
          settings,
        );
      case RoutePath.importFirstPage:
        final String passWord = settings.arguments as String;
        return _defaultRoute(
          OnBoardingImportKeyScreen(
            passWord: passWord,
          ),
          settings,
        );
      case RoutePath.recoverChoice:
        final String passWord = settings.arguments as String;
        return _defaultRoute(
          OnBoardingRecoverChoiceScreen(
            passWord: passWord,
          ),
          settings,
        );
      case RoutePath.recoverSelectAccount:
        return _defaultRoute(
          const OnBoardingRecoverSelectAccountScreen(),
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
