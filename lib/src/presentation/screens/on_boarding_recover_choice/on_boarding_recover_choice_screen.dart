import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'widgets/pick_recover_option_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';

import 'on_boarding_recover_choice_bloc.dart';
import 'on_boarding_recover_choice_state.dart';
import 'on_boarding_recover_choice_event.dart';

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
    extends State<OnBoardingRecoverChoiceScreen> with CustomFlutterToast {
  RecoverOptionType selectedType = RecoverOptionType.google;

  final OnBoardingRecoverChoiceBloc _bloc =
      getIt.get<OnBoardingRecoverChoiceBloc>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<OnBoardingRecoverChoiceBloc,
              OnBoardingRecoverChoiceState>(
            listener: (context, state) {
              switch (state.status) {
                case OnBoardingRecoverChoiceStatus.none:
                  break;
                case OnBoardingRecoverChoiceStatus.onLogin:
                  // _showLoadingDialog(appTheme);
                  break;
                case OnBoardingRecoverChoiceStatus.loginFailure:
                  // AppNavigator.pop();

                  showToast(state.errorMessage!);
                  break;
                case OnBoardingRecoverChoiceStatus.loginSuccess:

                  // AppNavigator.pop();
                  AppNavigator.push(
                    RoutePath.recoverSelectAccount,
                  );
                  break;
              }
            },
            child: Scaffold(
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
                            onSelect: (recoverType) {
                              selectedType = recoverType;
                            },
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
                            LanguageKey
                                .onBoardingRecoverChoiceScreenButtonTitle,
                          ),
                          onPress: () {
                            switch (selectedType) {
                              case RecoverOptionType.backupAddress:
                                AppNavigator.push(RoutePath.recoverBackup);
                                break;
                              case RecoverOptionType.google:
                                _bloc.add(const OnBoardingRecoverChoiceOnGoogleSignInEvent());
                                break;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWarningDialog(AppTheme appTheme) {
    /// Need to fix these text messages after apply business
    DialogProvider.showWarningDialog(
      context,
      title: AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingScanFeeScreenDialogWarningTitle,
      ),
      message: AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingScanFeeScreenDialogWarningContent,
      ),
      buttonTitle: AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingScanFeeScreenDialogWarningButtonTitle,
      ),
      onButtonTap: () => AppNavigator.pop(),
      appTheme: appTheme,
    );
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.instance
          .translate(LanguageKey.onBoardingScanFeeScreenDialogLoadingContent),
      appTheme: appTheme,
    );
  }
}
