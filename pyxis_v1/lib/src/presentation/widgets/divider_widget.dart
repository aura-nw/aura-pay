import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class HoLiZonTalDividerWidget extends StatelessWidget {
  final Color? dividerColor;
  final double? width;
  final double? height;

  const HoLiZonTalDividerWidget({
    this.dividerColor,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing03,
            vertical: Spacing.spacing02,
          ),
          color: dividerColor ?? appTheme.surfaceColorGrayDark,
          height: height ?? BoxSize.boxSize0,
          width: width,
        );
      },
    );
  }
}

class HoLiZonTalDividerWithTextWidget extends StatelessWidget {
  final String text;
  final Color? dividerColor;

  const HoLiZonTalDividerWithTextWidget({
    super.key,
    required this.text,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing03,
            vertical: Spacing.spacing02,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: dividerColor ?? appTheme.surfaceColorGrayDark,
                  height: BoxSize.boxSize0,
                  margin: const EdgeInsets.only(
                    right: Spacing.spacing04,
                  ),
                ),
              ),
              Text(
                text,
                style: AppTypoGraPhy.bodyMedium02.copyWith(
                  color: appTheme.contentColor700,
                ),
              ),
              Expanded(
                child: Container(
                  color: dividerColor ?? appTheme.surfaceColorGrayDark,
                  height: BoxSize.boxSize0,
                  margin: const EdgeInsets.only(
                    left: Spacing.spacing04,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DividerSeparator extends StatelessWidget {
  const DividerSeparator({
    Key? key,
    this.height = 1,
    this.color,
  }) : super(key: key);
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return AppThemeBuilder(
          builder: (theme) => Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color ?? theme.borderColorDisable,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
