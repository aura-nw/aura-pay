import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

final class _ChoiceOptionWidget extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String content;
  final String subContent;
  final VoidCallback onPress;
  final bool isRecommended;
  final AppLocalizationManager localization;

  const _ChoiceOptionWidget({
    required this.theme,
    required this.content,
    required this.subContent,
    required this.title,
    required this.onPress,
    required this.isRecommended,
    required this.localization,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPress,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      localization.translate(
                        title,
                      ),
                      style: AppTypoGraPhy.heading02.copyWith(
                        color: theme.contentColorBlack,
                      ),
                    ),
                    if (isRecommended) ...[
                      const SizedBox(
                        width: BoxSize.boxSize02,
                      ),
                      Container(
                        padding: const EdgeInsets.all(
                          Spacing.spacing02,
                        ),
                        decoration: BoxDecoration(
                          color: theme.surfaceColorBrandLight,
                          borderRadius: BorderRadius.circular(
                            BorderRadiusSize.borderRadius02,
                          ),
                        ),
                        child: Text(
                          localization.translate(
                            LanguageKey.onBoardingChoiceOptionScreenRecommended,
                          ),
                          style: AppTypoGraPhy.body02.copyWith(
                            color: theme.contentColorBrandDark,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  localization.translate(
                    content,
                  ),
                  style: AppTypoGraPhy.body01.copyWith(
                    color: theme.contentColor500,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  localization.translate(
                    subContent,
                  ),
                  style: AppTypoGraPhy.bodyMedium02.copyWith(
                    color: theme.contentColorBrandDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: BoxSize.boxSize07,
          ),
          SvgPicture.asset(
            AssetIconPath.commonArrowNext,
          ),
        ],
      ),
    );
  }
}

final class ChoiceOptionsWidget extends StatelessWidget {
  final AppLocalizationManager localization;
  final AppTheme appTheme;
  final VoidCallback onSmartAccountOptionPress;
  final VoidCallback onNormalWalletOptionPress;

  const ChoiceOptionsWidget({
    required this.appTheme,
    required this.localization,
    required this.onSmartAccountOptionPress,
    required this.onNormalWalletOptionPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChoiceOptionWidget(
          theme: appTheme,
          content: LanguageKey.onBoardingChoiceOptionScreenSmartAccountOptionContent,
          subContent: LanguageKey.onBoardingChoiceOptionScreenSmartAccountOptionMore,
          title: LanguageKey.onBoardingChoiceOptionScreenSmartAccountOption,
          onPress: onSmartAccountOptionPress,
          isRecommended: true,
          localization: localization,
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        const HoLiZonTalDividerWidget(),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        _ChoiceOptionWidget(
          theme: appTheme,
          content: LanguageKey.onBoardingChoiceOptionScreenNormalWalletOptionContent,
          subContent: LanguageKey.onBoardingChoiceOptionScreenNormalWalletOptionMore,
          title: LanguageKey.onBoardingChoiceOptionScreenNormalWalletOption,
          onPress: onNormalWalletOptionPress,
          isRecommended: false,
          localization: localization,
        ),
      ],
    );
  }
}
