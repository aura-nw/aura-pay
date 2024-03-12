import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_choice_option/widgets/choose_option_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'widgets/choice_option_widget.dart';

// ignore: must_be_immutable
class OnBoardingChoiceOptionScreen extends StatelessWidget {
  const OnBoardingChoiceOptionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(builder: (localization, _) {
          return Scaffold(
            backgroundColor: appTheme.bodyColorBackground,
            appBar: NormalAppBarWithOnlyTitleWidget(
              onViewMoreInformationTap: () {},
              appTheme: appTheme,
              title: localization.translate(
                LanguageKey.onBoardingChoiceOptionScreenAppBarTitle,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing05,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AssetIconPath.onBoardingChoiceOption,
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize10,
                    ),
                    ChoiceOptionsWidget(
                      appTheme: appTheme,
                      localization: localization,
                      onSmartAccountOptionPress: () => _showSmartAccountOptions(
                        context,
                        appTheme: appTheme,
                        localization: localization,
                      ),
                      onNormalWalletOptionPress: () => _showNormalWalletOptions(
                        context,
                        localization: localization,
                        appTheme: appTheme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showSmartAccountOptions(
    BuildContext context, {
    required AppTheme appTheme,
    required AppLocalizationManager localization,
  }) {
    AppBottomSheetLayout.showFullScreenDialog(
      context,
      child: ChooseOptionFormWidget(
        children: [
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenSmartAccountOptionCreateNewSmartAccount,
            ),
            content: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenSmartAccountOptionCreateNewSmartAccountContent,
            ),
            appTheme: appTheme,
            onTap: _onCreateSmartAccountClick,
          ),
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenSmartAccountOptionUseGoogle,
            ),
            content: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenSmartAccountOptionUseGoogleContent,
            ),
            appTheme: appTheme,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showNormalWalletOptions(
    BuildContext context, {
    required AppTheme appTheme,
    required AppLocalizationManager localization,
  }) {
    AppBottomSheetLayout.showFullScreenDialog(
      context,
      child: ChooseOptionFormWidget(
        children: [
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenNormalWalletOptionCreateWallet,
            ),
            content: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenNormalWalletOptionCreateWalletContent,
            ),
            appTheme: appTheme,
            onTap: _onCreateNewRandomNormalWalletClick,
          ),
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenNormalWalletOptionUseGoogle,
            ),
            content: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenNormalWalletOptionUseGoogleContent,
            ),
            appTheme: appTheme,
            onTap: () {},
          ),
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenNormalWalletOptionImportWallet,
            ),
            content: localization.translate(
              LanguageKey
                  .onBoardingChoiceOptionScreenNormalWalletOptionImportWalletContent,
            ),
            appTheme: appTheme,
            onTap: _onImportAccountClick,
          ),
        ],
      ),
    );
  }

  void _onCreateSmartAccountClick() {
    AppNavigator.push(
      RoutePath.pickAccountName,
    );
  }

  void _onImportAccountClick() {
    AppNavigator.push(
      RoutePath.importFirstPage,
    );
  }

  void _onCreateNewRandomNormalWalletClick() {
    AppNavigator.push(
      RoutePath.createNewWallet,
    );
  }

  void _onRecoverAccountClick() {
    AppNavigator.push(
      RoutePath.recoverChoice,
    );
  }
}
