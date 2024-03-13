import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'widgets/import_wallet_type_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

import 'widgets/account_type_widget.dart';

import 'on_boarding_import_key_event.dart';
import 'on_boarding_import_key_bloc.dart';
import 'on_boarding_import_key_state.dart';
import 'on_boarding_import_key_selector.dart';

class OnBoardingImportKeyScreen extends StatefulWidget {
  const OnBoardingImportKeyScreen({super.key});

  @override
  State<OnBoardingImportKeyScreen> createState() =>
      _OnBoardingImportKeyScreenState();
}

class _OnBoardingImportKeyScreenState extends State<OnBoardingImportKeyScreen>
    with CustomFlutterToast {
  final OnBoardingImportKeyBloc _bloc = getIt.get<OnBoardingImportKeyBloc>();

  bool _passWordIsHide = true;

  final Map<ImportWalletType, List<String>> _options = {
    ImportWalletType.privateKey: [
      AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingImportKeyScreenSelectTypePrivate,
      ),
      'E.g: 54c446f7d...31f28d6'
    ],
    ImportWalletType.passPhrase: [
      AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingImportKeyScreenSelectTypePassPhrase,
      ),
      'E.g: Hour keyboard mother bottle ...'
    ],
  };

  final GlobalKey<TextInputNormalSuffixState> _inputPrivateGlobalKey =
      GlobalKey();
  final GlobalKey<TextInputNormalSuffixState> _inputPassPhraseGlobalKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<OnBoardingImportKeyBloc, OnBoardingImportKeyState>(
            listener: (context, state) {
              switch (state.status) {
                case OnBoardingImportKeyStatus.init:
                  break;
                case OnBoardingImportKeyStatus.onImportAccountError:
                  AppNavigator.pop();

                  showToast(state.errorMessage!);
                  break;
                case OnBoardingImportKeyStatus.onImportAccountSuccess:
                  AppNavigator.pop();

                  switch (state.pyxisWalletType) {
                    case PyxisWalletType.smartAccount:
                      break;
                    case PyxisWalletType.normalWallet:
                      AppGlobalCubit.of(context).changeState(
                        const AppGlobalState(
                          status: AppGlobalStatus.authorized,
                          onBoardingStatus: OnBoardingStatus.importNormalAccountSuccessFul,
                        ),
                      );
                      break;
                  }
                  break;
                case OnBoardingImportKeyStatus.onLoading:
                  _showLoadingDialog(appTheme);
                  break;
              }
            },
            child: Scaffold(
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
                                  children: [
                                    TextSpan(
                                      text: localization.translate(
                                        LanguageKey
                                            .onBoardingImportKeyScreenTitleRegionOne,
                                      ),
                                      style: AppTypoGraPhy.heading06.copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .onBoardingImportKeyScreenTitleRegionTwo,
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
                          // const SizedBox(
                          //   height: BoxSize.boxSize07,
                          // ),
                          // AppLocalizationProvider(
                          //   builder: (localization, _) {
                          //     return Row(
                          //       children: [
                          //         Text(
                          //           localization.translate(
                          //             LanguageKey
                          //                 .onBoardingImportKeyScreenAccountType,
                          //           ),
                          //         ),
                          //         const SizedBox(
                          //           width: BoxSize.boxSize03,
                          //         ),
                          //         SvgPicture.asset(
                          //           AssetIconPath
                          //               .onBoardingImportKeyInformation,
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: BoxSize.boxSize05,
                          // ),
                          // OnBoardingImportKeyAccountTypeSelector(
                          //   builder: (accountType) {
                          //     return AccountTypeChoiceWidget(
                          //       onSelected: (selectedAccountType) {
                          //         if (selectedAccountType != accountType) {
                          //           _bloc.add(
                          //             OnBoardingImportKeyOnSelectAccountTypeEvent(
                          //               accountType: selectedAccountType,
                          //             ),
                          //           );
                          //         }
                          //       },
                          //       defaultType: accountType,
                          //       appTheme: appTheme,
                          //     );
                          //   },
                          // ),
                          const SizedBox(
                            height: BoxSize.boxSize07,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return OnBoardingImportKeyImportTypeSelector(
                                builder: (importType) {
                                  return ImportWalletTypeSelectWidget(
                                    data: _options.entries.toList(),
                                    selectedData: _options.entries
                                        .where((e) => e.key == importType)
                                        .toList(),
                                    onChange: (selectedTypes) {
                                      if (selectedTypes.isNotEmpty) {
                                        final selectedType =
                                            selectedTypes[0].key;

                                        _bloc.add(
                                          OnBoardingImportKeyOnSelectImportTypeEvent(
                                            importType: selectedType,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize05,
                          ),
                          OnBoardingImportKeyImportTypeSelector(
                            builder: (selectedType) {
                              switch (selectedType) {
                                case ImportWalletType.privateKey:
                                  return AppLocalizationProvider(
                                    builder: (localization, _) {
                                      return TextInputNormalSuffixWidget(
                                        suffix: _passWordIsHide
                                            ? SvgPicture.asset(
                                                AssetIconPath.commonEyeHide,
                                              )
                                            : SvgPicture.asset(
                                                AssetIconPath.commonEyeActive,
                                              ),
                                        isRequired: true,
                                        key: _inputPrivateGlobalKey,
                                        maxLine: 1,
                                        onChanged: (value, isValid) {
                                          if (isValid) {
                                            _bloc.add(
                                                OnBoardingImportKeyOnInputKeyEvent(
                                                    key: value));
                                          }
                                        },
                                        constraintManager: ConstraintManager(
                                          isStopWhenFirstFailure: true,
                                          isValidOnChanged: true,
                                        )..custom(
                                            errorMessage: localization
                                                .translate(LanguageKey
                                                    .onBoardingImportKeyScreenInvalidPrivateKey),
                                            customValid: (value) {
                                              try {
                                                return AuraWalletHelper
                                                    .checkPrivateKey(
                                                  value.trim(),
                                                );
                                              } catch (e) {
                                                return false;
                                              }
                                            },
                                          ),
                                        label: localization.translate(
                                          LanguageKey
                                              .onBoardingImportKeyScreenPrivateKey,
                                        ),
                                        obscureText: _passWordIsHide,
                                        onSuffixTap: () {
                                          setState(() {
                                            _passWordIsHide = !_passWordIsHide;
                                          });
                                        },
                                      );
                                    },
                                  );
                                case ImportWalletType.passPhrase:
                                  return AppLocalizationProvider(
                                    builder: (localization, _) {
                                      return TextInputNormalSuffixWidget(
                                        suffix: _passWordIsHide
                                            ? SvgPicture.asset(
                                                AssetIconPath.commonEyeHide,
                                              )
                                            : SvgPicture.asset(
                                                AssetIconPath.commonEyeActive,
                                              ),
                                        isRequired: true,
                                        maxLine: 1,
                                        key: _inputPassPhraseGlobalKey,
                                        onChanged: (value, isValid) {
                                          if (isValid) {
                                            _bloc.add(
                                                OnBoardingImportKeyOnInputKeyEvent(
                                                    key: value));
                                          }
                                        },
                                        constraintManager: ConstraintManager(
                                          isStopWhenFirstFailure: true,
                                          isValidOnChanged: true,
                                        )..custom(
                                            errorMessage:
                                                localization.translate(
                                              LanguageKey
                                                  .onBoardingImportKeyScreenInvalidPassPhrase,
                                            ),
                                            customValid: (value) {
                                              try {
                                                return AuraWalletHelper
                                                    .checkMnemonic(
                                                  mnemonic: value.trim(),
                                                );
                                              } catch (e) {
                                                return false;
                                              }
                                            },
                                          ),
                                        label: localization.translate(
                                          LanguageKey
                                              .onBoardingImportKeyScreenPassPhrase,
                                        ),
                                        obscureText: _passWordIsHide,
                                        onSuffixTap: () {
                                          setState(() {
                                            _passWordIsHide = !_passWordIsHide;
                                          });
                                        },
                                      );
                                    },
                                  );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return OnBoardingImportKeyIsReadySubmitSelector(
                          builder: (isDisable) {
                            return PrimaryAppButton(
                              text: localization.translate(
                                LanguageKey
                                    .onBoardingImportKeyScreenButtonTitle,
                              ),
                              isDisable: !isDisable,
                              onPress: () {
                                bool isValid = false;

                                switch (_bloc.state.importWalletType) {
                                  case ImportWalletType.privateKey:
                                    isValid = _inputPrivateGlobalKey
                                            .currentState
                                            ?.validate() ??
                                        false;
                                    break;
                                  case ImportWalletType.passPhrase:
                                    isValid = _inputPassPhraseGlobalKey
                                            .currentState
                                            ?.validate() ??
                                        false;
                                    break;
                                }

                                if (isValid) {
                                  _bloc.add(
                                    const OnBoardingImportKeyOnSubmitEvent(),
                                  );
                                }
                              },
                            );
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

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.onBoardingImportKeyScreenDialogLoadingTitle,
      ),
      appTheme: appTheme,
    );
  }
}
