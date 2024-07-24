import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/core/app_routes.dart';
import 'package:pyxis_v2/src/presentation/screens/create_passcode/create_passcode_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/generate_wallet/generate_wallet_creen.dart';
import 'package:pyxis_v2/src/presentation/screens/get_started/get_started_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/import_wallet/import_wallet_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/import_wallet_yeti_bot/import_wallet_yeti_bot_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/re_login/re_login_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/send/send_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/social_login_yeti_bot/social_login_yeti_bot_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/splash/spash_screen.dart';
import 'package:wallet_core/wallet_core.dart';

sealed class RoutePath {
  static const String _base = '/';
  static const String splash = _base;

  static const String _onBoarding = '${_base}onboarding';
  static const String reLogin = '$_onBoarding/re_login';
  static const String getStarted = '$_onBoarding/get_started';
  static const String setPasscode = '$_onBoarding/set_passcode';
  static const String createWallet = '$_onBoarding/create_wallet';
  static const String importWallet = '$_onBoarding/import_wallet';
  static const String importWalletYetiBot =
      '$_onBoarding/import_wallet_yeti_bot';
  static const String socialLoginYetiBot = '$_onBoarding/social_login_yeti_bot';

  static const String home = '${_base}home';

  static const String send = '$home/send';
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
          const GetStartedScreen(),
          settings,
        );
      case RoutePath.setPasscode:
        final Map<String, dynamic> argument =
            settings.arguments as Map<String, dynamic>;
        final void Function(BuildContext context) onCreatePasscodeDone =
            argument['callback'] as void Function(BuildContext);

        final bool canBack = argument['canBack'] as bool? ?? true;
        return _defaultRoute(
          CreatePasscodeScreen(
            onCreatePasscodeDone: onCreatePasscodeDone,
            canBack: canBack,
          ),
          settings,
        );
      case RoutePath.reLogin:
        return _defaultRoute(
          const ReLoginScreen(),
          settings,
        );
      case RoutePath.createWallet:
        return _defaultRoute(
          const GenerateWalletScreen(),
          settings,
        );
      case RoutePath.home:
        return _defaultRoute(
          const HomeScreen(),
          settings,
        );
      case RoutePath.importWallet:
        return _defaultRoute(
          const ImportWalletScreen(),
          settings,
        );
      case RoutePath.importWalletYetiBot:
        final AWallet aWallet = settings.arguments as AWallet;
        return _defaultRoute(
          ImportWalletYetiBotScreen(
            aWallet: aWallet,
          ),
          settings,
        );
      case RoutePath.socialLoginYetiBot:
        final AWallet aWallet = settings.arguments as AWallet;
        return _defaultRoute(
          SocialLoginYetiBotScreen(
            aWallet: aWallet,
          ),
          settings,
        );
      case RoutePath.send:
        return _defaultRoute(
          const SendScreen(),
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
