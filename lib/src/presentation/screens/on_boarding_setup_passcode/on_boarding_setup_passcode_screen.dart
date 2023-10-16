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
import 'widgets/input_password_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/key_board_number_widget.dart';

class OnBoardingSetupPasscodeScreen extends StatefulWidget {
  final OnboardingType onboardingType;

  const OnBoardingSetupPasscodeScreen({
    required this.onboardingType,
    super.key,
  });

  @override
  State<OnBoardingSetupPasscodeScreen> createState() =>
      _OnBoardingSetupPasscodeScreenState();
}

class _OnBoardingSetupPasscodeScreenState
    extends State<OnBoardingSetupPasscodeScreen> {
  int _fillIndex = -1;

  final PageController _pageController = PageController();

  final List<String> _password = [];
  final List<String> _confirmPassword = [];

  bool _wrongConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          appBar: AppBarStepWidget(
            appTheme: appTheme,
            onViewMoreInformationTap: () {},
          ),
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
                        if (_wrongConfirmPassword) ...[
                          const SizedBox(
                            height: Spacing.spacing04,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translate(
                                  LanguageKey
                                      .onBoardingSetupPasscodeScreenConfirmNotMatch,
                                ),
                                style: AppTypoGraPhy.utilityHelperSm.copyWith(
                                  color: appTheme.contentColorDanger,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ] else
                          const SizedBox()
                      ],
                    ),
                  ],
                ),
              ),
              KeyboardNumberWidget(
                rightIcon: SvgPicture.asset(
                  AssetIconPath.commonClear,
                ),
                rightButtonFn: _onClearPassword,
                onKeyboardTap: _onKeyBoardTap,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onClearPassword() {
    if (_fillIndex < 0) return;

    _fillIndex--;

    setState(() {});
  }

  void _onKeyBoardTap(String text) {
    if (_pageController.page == 0) {
      /// create password
      _fillIndex++;

      _password.add(text);

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
    } else {
      /// confirm password
      _fillIndex++;

      _confirmPassword.add(text);
      if (_fillIndex == 5) {
        if (_confirmPassword.join() != _password.join()) {
          /// show unMatch wrong
          _wrongConfirmPassword = true;
        } else {
          _wrongConfirmPassword = false;
        }

        _fillIndex = -1;

        String passWord = _password.join();

        switch (widget.onboardingType) {
          case OnboardingType.create:
            AppNavigator.push(
              RoutePath.pickAccountName,
              passWord,
            );
            break;
          case OnboardingType.import:
            AppNavigator.push(
              RoutePath.importFirstPage,
              passWord,
            );
            break;
          case OnboardingType.recover:
            AppNavigator.push(
              RoutePath.recoverChoice,
              passWord,
            );
            break;
        }
      }
    }
    setState(() {});
  }
}
