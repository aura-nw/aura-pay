import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';

class SocialLoginYetiBotAppBarTitleWidget extends StatelessWidget {
  final AppLocalizationManager localization;
  final AppTheme appTheme;

  const SocialLoginYetiBotAppBarTitleWidget({
    required this.appTheme,
    required this.localization,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetImagePath.yetiBot,
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        Text(
          localization.translate(
            LanguageKey.socialLoginYetiBotScreenYetiBot,
          ),
          style: AppTypoGraPhy.textMdBold.copyWith(
            color: appTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
