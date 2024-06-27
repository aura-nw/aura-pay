import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_confirm_recover_phrase/on_boarding_confirm_recover_phrase_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/phrase_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

class ConfirmRecoverPhraseContentWidget extends StatelessWidget {
  final TextEditingController confirmPhraseController;
  final TextEditingController walletNameController;
  final AppTheme appTheme;
  final List<String> words;
  final String wordSplit;
  final void Function(String) onChangeWalletName;
  final void Function(bool) onConfirmChange;

  const ConfirmRecoverPhraseContentWidget({
    required this.confirmPhraseController,
    required this.walletNameController,
    required this.appTheme,
    required this.words,
    required this.wordSplit,
    required this.onChangeWalletName,
    required this.onConfirmChange,
    super.key,
  });

  final int _maxWalletNameLength = 32;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SvgPicture.asset(
          AssetIconPath.commonShowKey,
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return RichText(
              text: TextSpan(
                style: AppTypoGraPhy.body03.copyWith(
                  color: appTheme.contentColor700,
                ),
                children: [
                  TextSpan(
                    text: localization.translate(
                      LanguageKey
                          .onBoardingConfirmRecoveryPhraseScreenContentRegionOne,
                    ),
                  ),
                  TextSpan(
                    text: ' ${localization.translate(
                      LanguageKey
                          .onBoardingConfirmRecoveryPhraseScreenContentRegionTwo,
                    )} ',
                    style: AppTypoGraPhy.bodyMedium03.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  ),
                  TextSpan(
                    text: localization.translate(
                      LanguageKey
                          .onBoardingConfirmRecoveryPhraseScreenContentRegionThree,
                    ),
                  ),
                  TextSpan(
                    text: ' ${localization.translateWithParam(
                      LanguageKey
                          .onBoardingConfirmRecoveryPhraseScreenContentRegionFour,
                      {'words': '4 , 5, 6'},
                    )} ',
                    style: AppTypoGraPhy.bodyMedium03.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  ),
                  TextSpan(
                    text: localization.translate(
                      LanguageKey
                          .onBoardingConfirmRecoveryPhraseScreenContentRegionFive,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return TextInputNormalWidget(
              controller: confirmPhraseController,
              hintText: localization.translateWithParam(
                LanguageKey.onBoardingConfirmRecoveryPhraseScreenHint,
                {'words': '4 , 5, 6'},
              ),
              onChanged: (_, isValid) {
                onConfirmChange(isValid);
              },
              constraintManager: ConstraintManager()
                ..custom(
                  errorMessage: localization.translate(
                    LanguageKey
                        .onBoardingConfirmRecoveryPhraseScreenIncorrectAnswer,
                  ),
                  customValid: _validateWord,
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
                LanguageKey.onBoardingConfirmRecoveryPhraseScreenEg,
              ),
              style: AppTypoGraPhy.body01.copyWith(
                color: appTheme.contentColor500,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        Container(
          padding: const EdgeInsets.all(
            Spacing.spacing03,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadius03,
            ),
            color: appTheme.surfaceColorGrayDefault,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: List.generate(
                    words.length,
                    (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.spacing02,
                          ),
                          child: PhraseWidget(
                            position: index + 4,
                            word: words[index],
                            appTheme: appTheme,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing02,
                  ),
                  child: Row(
                    children: [
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey.onBoardingConfirmRecoveryPhraseScreenDtn,
                            ),
                            style: AppTypoGraPhy.body02.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    LanguageKey
                        .onBoardingConfirmRecoveryPhraseScreenNameYourWallet,
                  ),
                  style: AppTypoGraPhy.utilityLabelSm.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                );
              },
            ),
            OnBoardingConfirmRecoverPhraseWalletNameSelector(
              builder: (walletName) {
                return Text(
                  '${walletName.trim().length}/$_maxWalletNameLength',
                  style: AppTypoGraPhy.bodyMedium01.copyWith(
                    color: appTheme.contentColor500,
                  ),
                );
              }
            ),
          ],
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return TextInputNormalWidget(
              maxLength: _maxWalletNameLength,
              controller: walletNameController,
              hintText: localization.translate(
                LanguageKey.onBoardingConfirmRecoveryPhraseScreenNameYourWallet,
              ),
              onChanged: (walletName, _) {
                onChangeWalletName(walletName);
              },
            );
          },
        ),
      ],
    );
  }

  bool _validateWord(String text){
    return text == wordSplit;
  }
}
