import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class AlreadyGoogleAccountWidget extends StatelessWidget {
  final AppTheme appTheme;
  final VoidCallback onSelectOther;

  const AlreadyGoogleAccountWidget({
    required this.appTheme,
    required this.onSelectOther,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetIconPath.commonWarning,
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                '',
              ),
              style: AppTypoGraPhy.body02.copyWith(
                color: appTheme.contentColor500,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize08,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return PrimaryAppButton(
              text: localization.translate(
                '',
              ),
              onPress: onSelectOther,
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return TextAppButton(
              text: localization.translate(
                '',
              ),
              onPress: () => AppNavigator.popUntil(
                RoutePath.choiceOption,
              ),
            );
          },
        ),
      ],
    );
  }
}
