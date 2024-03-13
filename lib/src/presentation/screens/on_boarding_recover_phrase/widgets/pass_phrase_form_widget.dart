import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/phrase_widget.dart';

class RecoveryPhraseWidget extends StatelessWidget {
  final String phrase;
  final void Function(String) onCopy;
  final AppTheme appTheme;

  const RecoveryPhraseWidget({
    required this.phrase,
    required this.onCopy,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> words = phrase.split(' ');
    return Column(
      children: [
        Column(
          children: List.generate(
            4,
            (cIndex) {
              return Row(
                children: List.generate(
                  3,
                  (rIndex) {
                    final index = cIndex * 3 + rIndex;
                    final String word = words[index];
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.spacing02,
                          vertical: Spacing.spacing03,
                        ),
                        child: PhraseWidget(
                          position: index + 1,
                          word: word,
                          appTheme: appTheme,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        GestureDetector(
          onTap: () => onCopy(phrase),
          behavior: HitTestBehavior.opaque,
          child: TextWithIconWidget(
            titlePath: LanguageKey.onBoardingRecoverPhraseScreenCopy,
            svgIconPath: AssetIconPath.commonCopyActive,
            appTheme: appTheme,
            style: AppTypoGraPhy.bodyMedium02.copyWith(
              color: appTheme.contentColorBrand,
            ),
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ],
    );
  }
}
