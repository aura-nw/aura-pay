import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  FadeRoute({required this.page, required RouteSettings settings})
      : super(
          pageBuilder: (context,animation, secondaryAnimation) => page,
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

  final Widget page;
}

class SlideRoute extends PageRouteBuilder {
  SlideRoute({required this.page, required RouteSettings settings})
      : super(
          pageBuilder: (context,animation, secondaryAnimation) => page,
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child){
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

  final Widget page;
}
