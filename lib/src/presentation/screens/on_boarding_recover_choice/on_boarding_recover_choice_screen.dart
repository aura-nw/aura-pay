import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_choice/widgets/pick_recover_option_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingRecoverChoiceScreen extends StatefulWidget {
  final String passWord;

  const OnBoardingRecoverChoiceScreen({
    required this.passWord,
    super.key,
  });

  @override
  State<OnBoardingRecoverChoiceScreen> createState() =>
      _OnBoardingRecoverChoiceScreenState();
}

class _OnBoardingRecoverChoiceScreenState
    extends State<OnBoardingRecoverChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: NormalAppBarWidget(
            appTheme: appTheme,
            onViewMoreInformationTap: () {},
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
                                  .onBoardingRecoverChoiceScreenTitleRegionOne,
                            ),
                            style: AppTypoGraPhy.heading06.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          ),
                          TextSpan(
                            text: ' ${localization.translate(
                              LanguageKey
                                  .onBoardingRecoverChoiceScreenTitleRegionTwo,
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
                        localization.translate(
                          LanguageKey.onBoardingRecoverChoiceScreenContent,
                        ),
                      ),
                      style: AppTypoGraPhy.body03.copyWith(
                        color: appTheme.contentColor500,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PickRecoverOptionWidget(
                        appTheme: appTheme,
                        onSelect: (recoverType) {},
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey.onBoardingRecoverChoiceScreenButtonTitle,
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
