import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class ScrollViewWidget extends StatelessWidget {
  final double width;
  final double height;
  final AppTheme appTheme;

  const ScrollViewWidget({
    this.width = BoxSize.boxSize11,
    this.height = BoxSize.boxSize02,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius03,
        ),
        color: appTheme.surfaceColorGrayDark,
      ),
    );
  }
}
