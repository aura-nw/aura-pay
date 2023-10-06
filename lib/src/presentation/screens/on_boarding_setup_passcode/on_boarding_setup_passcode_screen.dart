import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_setup_passcode/widgets/input_password_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/key_board_number_widget.dart';

class OnBoardingSetupPasscodeScreen extends StatefulWidget {
  const OnBoardingSetupPasscodeScreen({super.key});

  @override
  State<OnBoardingSetupPasscodeScreen> createState() =>
      _OnBoardingSetupPasscodeScreenState();
}

class _OnBoardingSetupPasscodeScreenState
    extends State<OnBoardingSetupPasscodeScreen> {
  int _fillIndex = -1;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translate(
                                LanguageKey
                                    .onBoardingSetupPasscodeScreenCreateTitle,
                              ),
                              style: AppTypoGraPhy.bodyMedium04.copyWith(
                                color: appTheme.contentColorBlack,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: Spacing.spacing04,
                        ),
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translate(
                                LanguageKey
                                    .onBoardingSetupPasscodeScreenCreateContent,
                              ),
                              style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                                color: appTheme.contentColor700,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: Spacing.spacing10,
                        ),
                        InputPasswordWidget(
                          length: 6,
                          appTheme: appTheme,
                          fillIndex: _fillIndex,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translate(
                                LanguageKey
                                    .onBoardingSetupPasscodeScreenConfirmTitle,
                              ),
                              style: AppTypoGraPhy.bodyMedium04.copyWith(
                                color: appTheme.contentColorBlack,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: Spacing.spacing10,
                        ),
                        InputPasswordWidget(
                          length: 6,
                          appTheme: appTheme,
                          fillIndex: _fillIndex,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              KeyboardNumberWidget(
                onKeyboardTap: (text) {
                  setState(() {
                    _fillIndex++;
                  });
                  if (_fillIndex == 5) {
                    _fillIndex = -1;
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      curve: Curves.bounceIn,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
