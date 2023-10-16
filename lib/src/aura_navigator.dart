import 'package:pyxis_mobile/src/core/app_routes.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_choice_option/on_boarding_choice_option_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_pick_account/on_boarding_pick_account_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_choice/on_boarding_recover_choice_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_scan_fee/on_boarding_scan_fee_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_setup_passcode/on_boarding_setup_passcode_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'presentation/screens/on_boarding_get_started/get_started_screen.dart';
import 'presentation/screens/on_boarding_import_key/on_boarding_import_key_screen.dart';

class RoutePath {
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
}

class AppNavigator {
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
        final String rawAddress = settings.arguments as String;
        return _defaultRoute(
          OnBoardingScanFeeScreen(
            rawAddress: rawAddress,
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
