import 'package:pyxis_mobile/src/core/app_routes.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class RoutePath {
  static const String _base = '/';
  static const String splash = _base;
  static const String setupWallet = '${_base}setup';
  static const String importWallet = '$setupWallet/import';
  static const String createWallet = '$setupWallet/create';
  static const String home = '${_base}home';
  static const String sentTransaction = '$home/sent_transaction';
  static const String scanQR = '$home/scan_QR';
  static const String contract = '$home/contract';
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
