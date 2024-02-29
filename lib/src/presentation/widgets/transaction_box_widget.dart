import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class TransactionBoxWidget extends StatelessWidget {
  final AppTheme appTheme;
  final Widget child;

  const TransactionBoxWidget({
    required this.appTheme,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing03,
        vertical: Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
        color: appTheme.surfaceColorGrayLight,
      ),
      child: child,
    );
  }
}
