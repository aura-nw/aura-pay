import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'widgets/count_down_timer_reviewing_widget.dart';
import 'widgets/smart_account_widget.dart';
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
              vertical: Spacing.spacing08 + kToolbarHeight,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: AppTypoGraPhy.heading06.copyWith(
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
                        height: BoxSize.boxSize08,
                      ),

                      ///Need to fix this when completed design,
                      SmartAccountWidget(
                        appTheme: appTheme,
                        smartAccountAddress: 'aura1kjch5a...0c4qmrdk',
                        smartAccountName: 'Pyxis account 1',
                        avatar:
                            'https://www.seiu1000.org/sites/main/files/main-images/camera_lense_0.jpeg',
                      ),
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
                      const SizedBox(
                        height: BoxSize.boxSize12,
                      ),
                      CountDownTimerReviewingWidget(
                        duration: 100000,
                        appTheme: appTheme,
                      ),
                    ],
                  ),
                ),
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
                      onPress: () => AppNavigator.pop(),
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
