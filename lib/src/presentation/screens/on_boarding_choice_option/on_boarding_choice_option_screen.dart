import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'widgets/choice_option_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

// ignore: must_be_immutable
class OnBoardingChoiceOptionScreen extends StatelessWidget {
  OnBoardingChoiceOptionScreen({super.key});

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetLogoPath.logo,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize06,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey.globalPyxisTitle,
                            ),
                            style: AppTypoGraPhy.heading04.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize03,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey.onBoardingChoiceOptionScreenTitle,
                            ),
                            style: AppTypoGraPhy.body03.copyWith(
                              color: appTheme.contentColor500,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    return AppLocalizationProvider(
                      builder: (localization, _) {
                        return Column(
                          children: [
                            ChoiceOptionWidget(
                              theme: appTheme,
                              isSelected: _selectedIndex == 0,
                              iconPath:
                                  AssetIconPath.onBoardingCreateAccountSelected,
                              title: localization.translate(
                                LanguageKey
                                    .onBoardingChoiceOptionScreenCreateSmartAccountTitle,
                              ),
                              content: localization.translate(
                                LanguageKey
                                    .onBoardingChoiceOptionScreenCreateSmartAccountContent,
                              ),
                              onPress: () {
                                AppNavigator.push(
                                  RoutePath.setupPasscode,
                                  OnboardingType.create,
                                );
                              },
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize04,
                            ),
                            HoLiZonTalDividerWithTextWidget(
                              text: localization.translate(
                                LanguageKey
                                    .onBoardingChoiceOptionScreenDividerText,
                              ),
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize04,
                            ),
                            ChoiceOptionWidget(
                                theme: appTheme,
                                isSelected: _selectedIndex == 1,
                                iconPath: AssetIconPath.onBoardingImportKey,
                                title: localization.translate(
                                  LanguageKey
                                      .onBoardingChoiceOptionScreenImportExistAccountTitle,
                                ),
                                content: localization.translate(
                                  LanguageKey
                                      .onBoardingChoiceOptionScreenImportExistAccountContent,
                                ),
                                onPress: () {
                                  AppNavigator.push(
                                    RoutePath.setupPasscode,
                                    OnboardingType.import,
                                  );
                                }),
                            const SizedBox(
                              height: BoxSize.boxSize07,
                            ),
                            ChoiceOptionWidget(
                                theme: appTheme,
                                isSelected: _selectedIndex == 2,
                                iconPath:
                                    AssetIconPath.onBoardingRecoverAccount,
                                title: localization.translate(
                                  LanguageKey
                                      .onBoardingChoiceOptionScreenRecoverAccountTitle,
                                ),
                                content: localization.translate(
                                  LanguageKey
                                      .onBoardingChoiceOptionScreenRecoverAccountContent,
                                ),
                                onPress: () {
                                  AppNavigator.push(
                                    RoutePath.setupPasscode,
                                    OnboardingType.recover,
                                  );
                                }),
                          ],
                        );
                      },
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
