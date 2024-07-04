import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';

class GetStartedButtonFormWidget extends StatelessWidget {
  final AppLocalizationManager localization;
  final AppTheme appTheme;
  final VoidCallback onCreateNewWallet;
  final VoidCallback onImportExistingWallet;
  final VoidCallback onTermClick;

  const GetStartedButtonFormWidget({
    required this.localization,
    required this.appTheme,
    required this.onCreateNewWallet,
    required this.onImportExistingWallet,
    required this.onTermClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryAppButton(
          text: localization.translate(
            LanguageKey.getStartedScreenCreateNewWallet,
          ),
          onPress: onCreateNewWallet,
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        BorderAppButton(
          text: localization.translate(
            LanguageKey.getStartedScreenAddWallet,
          ),
          onPress: onImportExistingWallet,
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        Text(
          localization.translate(
            LanguageKey.getStartedScreenOrContinueWith,
          ),
          style: AppTypoGraPhy.textXsRegular.copyWith(
            color: appTheme.textTertiary,
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        RichText(
          text: TextSpan(
            style: AppTypoGraPhy.textXsRegular.copyWith(
              color: appTheme.textTertiary,
            ),
            children: [
              TextSpan(
                text: '${localization.translate(
                  LanguageKey.getStartedScreenTermRegionOne,
                )} ',
              ),
              TextSpan(
                text: localization.translate(
                  LanguageKey.getStartedScreenTermRegionTwo,
                ),
                style: AppTypoGraPhy.textXsRegular.copyWith(
                  color: appTheme.textBrandPrimary,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTermClick
              ),
            ],
          ),
        ),
      ],
    );
  }
}
