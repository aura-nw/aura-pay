import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingImportSelectAccountScreen extends StatefulWidget {
  final String passWord;

  const OnBoardingImportSelectAccountScreen({
    required this.passWord,
    super.key,
  });

  @override
  State<OnBoardingImportSelectAccountScreen> createState() =>
      _OnBoardingImportSelectAccountScreenState();
}

class _OnBoardingImportSelectAccountScreenState
    extends State<OnBoardingImportSelectAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: NormalAppBarWidget(
            appTheme: appTheme,
            onViewMoreInformationTap: () {},
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing05,
                vertical: Spacing.spacing07,
              ),
              child: Column(
                children: [
                  Expanded(
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
                                          .onBoardingImportSelectAccountScreenTitleRegionOne,
                                    ),
                                    style: AppTypoGraPhy.heading05.copyWith(
                                      color: appTheme.contentColorBlack,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${localization.translate(
                                      LanguageKey
                                          .onBoardingImportSelectAccountScreenTitleRegionTwo,
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
                                    .onBoardingImportSelectAccountScreenContent,
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
                      ],
                    ),
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        text: localization.translate(
                          LanguageKey
                              .onBoardingImportSelectAccountScreenButtonTitle,
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
}
