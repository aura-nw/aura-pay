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
import 'signed_in_choice_option_cubit.dart';
import 'signed_in_choice_option_state.dart';
import 'widgets/choose_option_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'widgets/choice_option_widget.dart';

class SignedInChoiceOptionScreen extends StatefulWidget {
  const SignedInChoiceOptionScreen({
    super.key,
  });

  @override
  State<SignedInChoiceOptionScreen> createState() =>
      _SignedInChoiceOptionScreenState();
}

class _SignedInChoiceOptionScreenState extends State<SignedInChoiceOptionScreen>
    with CustomFlutterToast {
  final SignedInChoiceOptionCubit _cubit =
      getIt.get<SignedInChoiceOptionCubit>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(
          builder: (localization, _) {
            return BlocProvider.value(
              value: _cubit,
              child: BlocListener<SignedInChoiceOptionCubit,
                  SignedInChoiceOptionState>(
                listener: (context, state) {
                  switch (state.status) {
                    case SignedInChoiceOptionStatus.none:
                      break;
                    case SignedInChoiceOptionStatus.loginSuccess:
                      AppNavigator.push(
                        RoutePath.signedInRecoverSelectAccount,
                        state.googleAccount,
                      );
                      break;
                    case SignedInChoiceOptionStatus.loginFailure:
                      showToast(state.errorMessage ?? '');
                      break;
                    case SignedInChoiceOptionStatus.onLogin:
                      break;
                  }
                },
                child: Scaffold(
                  backgroundColor: appTheme.bodyColorBackground,
                  appBar: NormalAppBarWithTitleWidget(
                    onViewMoreInformationTap: () {},
                    appTheme: appTheme,
                    title: localization.translate(
                      LanguageKey.signedInChoiceOptionScreenAppBarTitle,
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
                            AssetIconPath.signedInChoiceOption,
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
          },
        );
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
                  .signedInChoiceOptionScreenSmartAccountOptionCreateNewSmartAccount,
            ),
            content: localization.translate(
              LanguageKey
                  .signedInChoiceOptionScreenSmartAccountOptionCreateNewSmartAccountContent,
            ),
            appTheme: appTheme,
            onTap: _onCreateSmartAccountClick,
          ),
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey.signedInChoiceOptionScreenSmartAccountOptionUseGoogle,
            ),
            content: localization.translate(
              LanguageKey
                  .signedInChoiceOptionScreenSmartAccountOptionUseGoogleContent,
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
                  .signedInChoiceOptionScreenNormalWalletOptionCreateWallet,
            ),
            content: localization.translate(
              LanguageKey
                  .signedInChoiceOptionScreenNormalWalletOptionCreateWalletContent,
            ),
            appTheme: appTheme,
            onTap: _onCreateNewRandomNormalWalletClick,
          ),
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey.signedInChoiceOptionScreenNormalWalletOptionUseGoogle,
            ),
            content: localization.translate(
              LanguageKey
                  .signedInChoiceOptionScreenNormalWalletOptionUseGoogleContent,
            ),
            appTheme: appTheme,
            onTap: _onCreateNewNormalWalletByGoogle,
          ),
          ChooseOptionWidget(
            title: localization.translate(
              LanguageKey
                  .signedInChoiceOptionScreenNormalWalletOptionImportWallet,
            ),
            content: localization.translate(
              LanguageKey
                  .signedInChoiceOptionScreenNormalWalletOptionImportWalletContent,
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
      RoutePath.signedInCreateNewAccountPickName,
    );
  }

  void _onImportAccountClick() {
    AppNavigator.push(
      RoutePath.signedInImportKey,
    );
  }

  void _onCreateNewRandomNormalWalletClick() {
    AppNavigator.push(
      RoutePath.signedInCreateNewWallet,
    );
  }

  void _onRecoverAccountClick() {
    _cubit.onRecoverAccountClick();
  }

  void _onCreateNewNormalWalletByGoogle() {
    AppNavigator.push(
      RoutePath.signedInCreateNormalWalletByGoogle,
    );
  }
}
