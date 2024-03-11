import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class RecoverPhraseRemindWidget extends StatelessWidget {
  final AppTheme appTheme;

  const RecoverPhraseRemindWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(''),
              style: AppTypoGraPhy.bodyMedium04.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(''),
              style: AppTypoGraPhy.body02.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(''),
              style: AppTypoGraPhy.bodyMedium04.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(''),
              style: AppTypoGraPhy.bodyMedium04.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
      ],
    );
  }
}
