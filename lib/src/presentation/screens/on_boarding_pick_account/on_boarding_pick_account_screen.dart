import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class OnBoardingPickAccountScreen extends StatefulWidget {
  final String passWord;

  const OnBoardingPickAccountScreen({required this.passWord, super.key});

  @override
  State<OnBoardingPickAccountScreen> createState() =>
      _OnBoardingPickAccountScreenState();
}

class _OnBoardingPickAccountScreenState
    extends State<OnBoardingPickAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          appBar: AppBarStepWidget(
            appTheme: appTheme,
            onViewMoreInformationTap: () {},
            currentStep: 1,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return RichText(
                            text: TextSpan(
                              style: AppTypoGraPhy.heading05.copyWith(
                                color: appTheme.contentColorBlack,
                              ),
                              children: [
                                TextSpan(
                                  text: localization.translate(
                                    LanguageKey
                                        .onBoardingCreateNewSmartAccountScreenTitleRegionOne,
                                  ),
                                  style: AppTypoGraPhy.heading06.copyWith(
                                    color: appTheme.contentColorBrand,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${localization.translate(
                                    LanguageKey
                                        .onBoardingCreateNewSmartAccountScreenTitleRegionTwo,
                                  )}',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize08,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AssetIconPath.commonLogo,
                          ),
                          const SizedBox(
                            width: BoxSize.boxSize04,
                          ),
                          Expanded(
                            child: AppLocalizationProvider(
                              builder: (localization, _) {
                                return TextInputNormalWidget(
                                  label: localization.translate(
                                    LanguageKey
                                        .onBoardingCreateNewSmartAccountScreenTextFieldTitle,
                                  ),
                                  isRequired: true,
                                  onChanged: (value, isValid) {},
                                  hintText: 'Input account name',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingCreateNewSmartAccountScreenButtonTitle,
                      ),
                      onPress: () {
                        AppNavigator.push(
                          RoutePath.scanQrFee,
                          'aura1j6kwc0l1l2g2zu0aq095sc24as2sss21',
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
