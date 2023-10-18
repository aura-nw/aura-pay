import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingRecoverRequestReviewingScreen extends StatefulWidget {
  const OnBoardingRecoverRequestReviewingScreen({super.key});

  @override
  State<OnBoardingRecoverRequestReviewingScreen> createState() =>
      _OnBoardingRecoverRequestReviewingScreenState();
}

class _OnBoardingRecoverRequestReviewingScreenState
    extends State<OnBoardingRecoverRequestReviewingScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
              children: [
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: localization.translate(
                              LanguageKey
                                  .onBoardingRecoverRequestReviewingScreenTitleRegionOne,
                            ),
                            style: AppTypoGraPhy.heading05.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          ),
                          TextSpan(
                            text: ' ${localization.translate(
                              LanguageKey
                                  .onBoardingRecoverRequestReviewingScreenTitleRegionTwo,
                            )}',
                            style: AppTypoGraPhy.heading05.copyWith(
                              color: appTheme.contentColorBrand,
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

                ///Smart account widget here
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        LanguageKey
                            .onBoardingRecoverRequestReviewingScreenContent,
                      ),
                      style: AppTypoGraPhy.body03.copyWith(
                        color: appTheme.contentColor500,
                      ),
                    );
                  },
                ),

                ///Count down widget here
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingRecoverRequestReviewingScreenNotifyButtonTitle,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return BorderAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingRecoverRequestReviewingScreenBackButtonTitle,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
