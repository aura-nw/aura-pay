import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class AlertBackupPrivateKeyWidget extends StatelessWidget {
  final AppTheme appTheme;

  const AlertBackupPrivateKeyWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorBrandLight,
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
              '',
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        '',
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
                        '',
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
            AssetIconPath.commonArrowNext,
          ),
        ],
      ),
    );
  }
}
