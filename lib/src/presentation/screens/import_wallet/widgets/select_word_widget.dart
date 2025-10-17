import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/asset_path.dart';
import 'package:aurapay/src/core/constants/language_key.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';

final class SelectWordWidget extends StatelessWidget {
  final int word;
  final int currentWord;
  final AppTheme appTheme;
  final AppLocalizationManager localization;
  final void Function(int) onSelected;

  const SelectWordWidget({
    required this.word,
    required this.currentWord,
    required this.appTheme,
    required this.localization,
    required this.onSelected,
    super.key,
  });

  bool get isSelected => word == currentWord;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(word),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(
          Spacing.spacing04,
        ),
        decoration: BoxDecoration(
          color: isSelected ? appTheme.bgBrandPrimary : appTheme.bgPrimary,
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius04,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                localization.translateWithParam(
                  LanguageKey.importWalletScreenSeedPhraseWords,
                  {
                    'words': word,
                  },
                ),
                style: AppTypoGraPhy.textMdSemiBold.copyWith(
                  color: appTheme.textPrimary,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              SvgPicture.asset(
                AssetIconPath.icCommonYetiHand,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
