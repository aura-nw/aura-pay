import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.onBoardingRecoverPhraseScreenRemindTitle,
              ),
              style: AppTypoGraPhy.bodyMedium04.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.onBoardingRecoverPhraseScreenRemindOne,
              ),
              style: AppTypoGraPhy.body02.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.onBoardingRecoverPhraseScreenRemindTwo,
              ),
              style: AppTypoGraPhy.body02.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.onBoardingRecoverPhraseScreenRemindThree,
              ),
              style: AppTypoGraPhy.body02.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
      ],
    );
  }
}
