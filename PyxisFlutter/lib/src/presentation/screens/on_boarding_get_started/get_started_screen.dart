import 'package:domain/domain.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingGetStartedScreen extends StatelessWidget {
  const OnBoardingGetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing07,
                vertical: Spacing.spacing04,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: BoxSize.boxSize13,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                LanguageKey.onBoardingGetStartedScreenTitle,
                              ),
                              textAlign: TextAlign.center,
                              style: AppTypoGraPhy.body03.copyWith(
                                color: appTheme.contentColor500,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        text: localization.translate(
                          LanguageKey.onBoardingGetStartedScreenButtonTitle,
                        ),
                        onPress: _onStartedClick,
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize04,
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.spacing04,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: localization.translate(
                                  LanguageKey
                                      .onBoardingGetStartedScreenPrivacyPolicyTitleRegionOne,
                                ),
                                style: AppTypoGraPhy.body01.copyWith(
                                  color: appTheme.contentColor500,
                                ),
                              ),
                              TextSpan(
                                text: ' ${localization.translate(
                                  LanguageKey
                                      .onBoardingGetStartedScreenTermOfService,
                                )} ',
                                style: AppTypoGraPhy.body01.copyWith(
                                  color: appTheme.contentColorBrand,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    /// Open URL or show term service screen
                                  },
                              ),
                              TextSpan(
                                text: localization.translate(
                                  LanguageKey
                                      .onBoardingGetStartedScreenPrivacyPolicyTitleRegionTwo,
                                ),
                                style: AppTypoGraPhy.body01.copyWith(
                                  color: appTheme.contentColor500,
                                ),
                              ),
                              TextSpan(
                                text: ' ${localization.translate(
                                  LanguageKey
                                      .onBoardingGetStartedScreenPrivacyPolicy,
                                )}',
                                style: AppTypoGraPhy.body01.copyWith(
                                  color: appTheme.contentColorBrand,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    /// Open URL or show privacy policy screen
                                  },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onStartedClick() async {
    final appSecureUseCase = getIt.get<AppSecureUseCase>();

    final bool hasPassCode = await appSecureUseCase.hasPassCode(
      key: AppLocalConstant.passCodeKey,
    );

    if(hasPassCode){
      AppNavigator.push(
        RoutePath.choiceOption,
      );
    }else{
      AppNavigator.push(
        RoutePath.setupPasscode,
      );
    }
  }
}
