import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

final class IconWithTextWidget extends StatelessWidget {
  final String titlePath;
  final String svgIconPath;
  final AppTheme appTheme;
  final TextStyle ?style;
  final MainAxisAlignment mainAxisAlignment;

  const IconWithTextWidget({
    required this.titlePath,
    required this.svgIconPath,
    required this.appTheme,
    this.style,
    this.mainAxisAlignment = MainAxisAlignment.start,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SvgPicture.asset(
          svgIconPath,
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                titlePath,
              ),
              style: style ?? AppTypoGraPhy.bodyMedium03.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
      ],
    );
  }
}