import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'on_boarding_choice_option_cubit.dart';
import 'widgets/choose_option_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'on_boarding_choice_option_state.dart';
import 'widgets/choice_option_widget.dart';

class OnBoardingChoiceOptionScreen extends StatefulWidget {
  const OnBoardingChoiceOptionScreen({
    super.key,
  });

  @override
  State<OnBoardingChoiceOptionScreen> createState() =>
      _OnBoardingChoiceOptionScreenState();
}

class _OnBoardingChoiceOptionScreenState
    extends State<OnBoardingChoiceOptionScreen> with CustomFlutterToast {
  final OnBoardingChoiceOptionCubit _cubit =
      getIt.get<OnBoardingChoiceOptionCubit>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(builder: (localization, _) {
          return BlocProvider.value(
            value: _cubit,
            child: BlocListener<OnBoardingChoiceOptionCubit,
                OnBoardingChoiceOptionState>(
              listener: (context, state) {
                switch (state.status) {
                  case OnBoardingChoiceOptionStatus.none:
                    break;
                  case OnBoardingChoiceOptionStatus.loginSuccess:
                    AppNavigator.push(
                      RoutePath.recoverSelectAccount,
                      state.googleAccount,
                    );
                    break;
                  case OnBoardingChoiceOptionStatus.loginFailure:
                    showToast(state.errorMessage ?? '');
                    break;
                  case OnBoardingChoiceOptionStatus.onLogin:
                    break;
                }
              },
              child: Scaffold(
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
                          onSmartAccountOptionPress: () =>
                              _showSmartAccountOptions(
                            context,
                            appTheme: appTheme,
                            localization: localization,
                          ),
                          onNormalWalletOptionPress: () =>
                              _showNormalWalletOptions(
                            context,
                            localization: localization,
                            appTheme: appTheme,
                          ),
                        ),
                      ],
                    ),
                  ),
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
            onTap: _onRecoverAccountClick,
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
            onTap: _onCreateNewNormalWalletByGoogle,
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
    _cubit.onRecoverAccountClick();
  }

  void _onCreateNewNormalWalletByGoogle() {
    AppNavigator.push(
      RoutePath.createNewWalletByGoogle,
    );
  }
}
