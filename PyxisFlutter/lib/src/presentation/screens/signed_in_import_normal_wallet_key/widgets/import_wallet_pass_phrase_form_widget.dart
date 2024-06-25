import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/fill_words_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

class ImportWalletPassPhraseFormWidget extends StatelessWidget {
  final int wordCount;
  final AppLocalizationManager localization;
  final AppTheme appTheme;
  final VoidCallback onPaste;
  final GlobalKey<FillWordsWidgetState> fillWordKey;
  final ConstraintManager ?constraintManager;
  final void Function(String,bool) ?onWordChanged;

  const ImportWalletPassPhraseFormWidget({
    this.wordCount = 12,
    required this.appTheme,
    required this.localization,
    required this.onPaste,
    required this.fillWordKey,
    this.constraintManager,
    this.onWordChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: localization.translate(
                      LanguageKey
                          .signedInImportNormalWalletKeyScreenPassPhrase,
                    ),
                    style: AppTypoGraPhy.utilityLabelSm.copyWith(
                      color: appTheme.contentColor700,
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: AppTypoGraPhy.utilityLabelSm.copyWith(
                      color: appTheme.contentColorDanger,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onPaste,
              behavior: HitTestBehavior.opaque,
              child: TextWithIconWidget(
                titlePath: localization.translate(
                  LanguageKey.signedInImportNormalWalletKeyScreenPaste,
                ),
                svgIconPath: AssetIconPath.commonPaste,
                appTheme: appTheme,
                style: AppTypoGraPhy.bodyMedium02.copyWith(
                  color: appTheme.contentColorBrand,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        FillWordsWidget(
          appTheme: appTheme,
          wordCount: wordCount,
          key: fillWordKey,
          onWordChanged: onWordChanged,
          constraintManager: constraintManager,
        ),
      ],
    );
  }
}
