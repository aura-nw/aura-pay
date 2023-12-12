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
import 'signed_in_recover_choice_bloc.dart';
import 'signed_in_recover_choice_event.dart';
import 'signed_in_recover_choice_state.dart';
import 'widgets/pick_recover_option_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';

class SignedInRecoverChoiceScreen extends StatefulWidget {
  const SignedInRecoverChoiceScreen({
    super.key,
  });

  @override
  State<SignedInRecoverChoiceScreen> createState() =>
      _SignedInRecoverChoiceScreenState();
}

class _SignedInRecoverChoiceScreenState
    extends State<SignedInRecoverChoiceScreen> with CustomFlutterToast {
  /// Fake for deploy test flight
  RecoverOptionType selectedType = RecoverOptionType.backupAddress;

  final SignedInRecoverChoiceBloc _bloc =
      getIt.get<SignedInRecoverChoiceBloc>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<SignedInRecoverChoiceBloc,
              SignedInRecoverChoiceState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInRecoverChoiceStatus.none:
                  break;
                case SignedInRecoverChoiceStatus.onLogin:
                  // _showLoadingDialog(appTheme);
                  break;
                case SignedInRecoverChoiceStatus.loginFailure:
                  // AppNavigator.pop();

                  showToast(state.errorMessage!);
                  break;
                case SignedInRecoverChoiceStatus.loginSuccess:
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
                                      .signedInRecoverChoiceScreenTitleRegionOne,
                                ),
                                style: AppTypoGraPhy.heading06.copyWith(
                                  color: appTheme.contentColorBlack,
                                ),
                              ),
                              TextSpan(
                                text: ' ${localization.translate(
                                  LanguageKey
                                      .signedInRecoverChoiceScreenTitleRegionTwo,
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
                              LanguageKey.signedInRecoverChoiceScreenContent,
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
                            LanguageKey.signedInRecoverChoiceScreenButtonTitle,
                          ),
                          onPress: () {
                            switch (selectedType) {
                              case RecoverOptionType.backupAddress:
                                AppNavigator.push(RoutePath.recoverBackup);
                                break;
                              case RecoverOptionType.google:
                                _bloc.add(
                                  const SignedInRecoverChoiceEventOnGoogleSignIn(),
                                );
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
