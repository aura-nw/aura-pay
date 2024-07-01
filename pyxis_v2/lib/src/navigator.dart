import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/core/app_routes.dart';
import 'package:pyxis_v2/src/presentation/screens/splash/spash_screen.dart';

sealed class RoutePath {
  static const String _base = '/';
  static const String splash = _base;

  static const String _onBoarding = '${_base}onboarding';
  static const String reLogin = '$_onBoarding/re_login';
  static const String getStarted = '$_onBoarding/get_started';

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
