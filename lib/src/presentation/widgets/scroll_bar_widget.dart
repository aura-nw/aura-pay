import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class ScrollBarWidget extends StatelessWidget {
  final AppTheme appTheme;
  final Widget child;
  final double? thickness;
  final ScrollController? scrollController;

  const ScrollBarWidget({
    required this.appTheme,
    required this.child,
    this.scrollController,
    this.thickness,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(
        BorderRadiusSize.borderRadiusRound,
      ),
      thickness: thickness,
      thumbColor: appTheme.surfaceColorBlack.withOpacity(
        0.5,
      ),
      interactive: true,
      child: child,
    );
  }
}
