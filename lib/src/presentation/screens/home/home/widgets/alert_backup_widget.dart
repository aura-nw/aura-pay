import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class AlertBackupPrivateKeyWidget extends StatelessWidget {
  final AppTheme appTheme;
  final VoidCallback onTap;

  const AlertBackupPrivateKeyWidget({
    required this.appTheme,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(
          Spacing.spacing04,
        ),
        decoration: BoxDecoration(
          color: appTheme.warningColorLight,
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius04,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                AssetIconPath.homePageAlert,
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.homePageAlertBackupTitle,
                        ),
                        style: AppTypoGraPhy.utilityLabelSm.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize02,
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.homePageAlertBackupContent,
                        ),
                        style: AppTypoGraPhy.body01.copyWith(
                          color: appTheme.contentColor700,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AssetIconPath.homePageAlertNext,
            ),
          ],
        ),
      ),
    );
  }
}
