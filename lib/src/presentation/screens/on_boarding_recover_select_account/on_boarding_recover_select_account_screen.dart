import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'widgets/smart_account_widget.dart';

class OnBoardingRecoverSelectAccountScreen extends StatefulWidget {
  const OnBoardingRecoverSelectAccountScreen({super.key});

  @override
  State<OnBoardingRecoverSelectAccountScreen> createState() =>
      _OnBoardingRecoverSelectAccountScreenState();
}

class _OnBoardingRecoverSelectAccountScreenState
    extends State<OnBoardingRecoverSelectAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: NormalAppBarWidget(
            onViewMoreInformationTap: () {},
            appTheme: appTheme,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
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
                                  .onBoardingRecoverSelectAccountScreenTitleRegionOne,
                            ),
                            style: AppTypoGraPhy.heading06.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          ),
                          TextSpan(
                            text: ' ${localization.translate(
                              LanguageKey
                                  .onBoardingRecoverSelectAccountScreenTitleRegionTwo,
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
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        LanguageKey.onBoardingRecoverSelectAccountScreenContent,
                      ),
                      style: AppTypoGraPhy.body03.copyWith(
                        color: appTheme.contentColor500,
                      ),
                    );
                  },
                ),
                Expanded(
                  /// Need to fix this after apply BE
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.spacing07,
                    ),
                    reverse: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: Spacing.spacing05,
                        ),
                        child: SmartAccountWidget(
                          appTheme: appTheme,
                          smartAccountAddress: 'aura1kjch5a...0c4qmrdk',
                          smartAccountName: 'Pyxis Account ${index + 1}',
                          avatar:
                              'https://www.seiu1000.org/sites/main/files/main-images/camera_lense_0.jpeg',
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingRecoverSelectAccountScreenButtonTitle,
                      ),
                      onPress: () {
                        AppNavigator.push(
                          RoutePath.recoverReviewing,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
