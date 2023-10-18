import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

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
                            style: AppTypoGraPhy.heading05.copyWith(
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
                        LanguageKey
                            .onBoardingRecoverSelectAccountScreenContent,
                      ),
                      style: AppTypoGraPhy.body03.copyWith(
                        color: appTheme.contentColor500,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: ListView(
                    children: [],
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingRecoverSelectAccountScreenButtonTitle,
                      ),
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
