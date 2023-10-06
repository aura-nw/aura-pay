import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class HoLiZonTalDividerWidget extends StatelessWidget {
  const HoLiZonTalDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (p0) {
        return Row(
          children: [
            Container(),
          ],
        );
      },
    );
  }
}

class HoLiZonTalDividerWithTextWidget extends StatelessWidget {
  final String text;

  const HoLiZonTalDividerWithTextWidget({
    super.key,
    required this.text,
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
                  color: appTheme.surfaceColorGrayDark,
                  height: Spacing.spacing0,
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
                  color: appTheme.surfaceColorGrayDark,
                  height: Spacing.spacing0,
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
