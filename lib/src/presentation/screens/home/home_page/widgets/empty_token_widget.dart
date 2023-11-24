import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class EmptyTokenWidget extends StatelessWidget {
  final AppTheme appTheme;

  const EmptyTokenWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetIconPath.homeNoTokenFound,
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.homePageNoTokenFoundTitle,
              ),
              style: AppTypoGraPhy.heading02.copyWith(
                color: appTheme.contentColor500,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.homePageNoTokenFoundContent,
              ),
              style: AppTypoGraPhy.body02.copyWith(
                color: appTheme.contentColor500,
              ),
            );
          },
        ),
      ],
    );
  }
}
