import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class SettingSecureOptionWidget extends StatelessWidget {
  final String iconPath;
  final String labelPath;
  final AppTheme appTheme;
  final VoidCallback onTap;
  final Widget prefix;

  const SettingSecureOptionWidget({
    required this.iconPath,
    required this.labelPath,
    required this.appTheme,
    required this.onTap,
    required this.prefix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: Spacing.spacing04, top: Spacing.spacing04),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            Expanded(
              child: AppLocalizationProvider(
                builder: (localization, _) {
                  return Text(
                    localization.translate(
                      labelPath,
                    ),
                    style: AppTypoGraPhy.bodyMedium03.copyWith(
                      color: appTheme.contentColor700,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            prefix,
          ],
        ),
      ),
    );
  }
}
