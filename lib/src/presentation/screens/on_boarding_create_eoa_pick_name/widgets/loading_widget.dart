import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class CreateEOALoadingWidget extends StatelessWidget {
  final AppTheme appTheme;

  const CreateEOALoadingWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          AssetLogoPath.logo,
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Column(
              children: [
                Text(
                  localization.translate(
                    '',
                  ),
                  style: AppTypoGraPhy.bodyMedium02.copyWith(
                    color: appTheme.contentColor700,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize03,
                ),
                Text(
                  localization.translate(
                    '',
                  ),
                  style: AppTypoGraPhy.bodyMedium02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
