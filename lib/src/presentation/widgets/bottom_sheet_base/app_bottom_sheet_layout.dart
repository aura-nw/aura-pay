import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';

class AppBottomSheetLayout extends StatelessWidget {
  final Widget child;

  const AppBottomSheetLayout({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: appTheme.bodyColorOverlay.withOpacity(
              0.6,
            ),
            body: Stack(
              children: [
                Positioned(
                  bottom: BoxSize.boxSize10,
                  child: SizedBox(
                    width: context.w,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.spacing07,
                        vertical: Spacing.spacing08,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<T?> showFullScreenDialog<T>(BuildContext context, {
    required Widget child,
  }) {
    return showGeneralDialog<T>(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppBottomSheetLayout(
          child: child,
        );
      },
    );
  }
}
