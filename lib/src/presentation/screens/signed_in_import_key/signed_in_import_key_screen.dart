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
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/choice_select_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

import 'signed_in_import_key_bloc.dart';
import 'signed_in_import_key_selector.dart';
import 'signed_in_import_key_state.dart';
import 'singed_in_import_key_event.dart';
import 'widgets/acocunt_type_widget.dart';

class SignedInImportKeyScreen extends StatefulWidget {
  const SignedInImportKeyScreen({
    super.key,
  });

  @override
  State<SignedInImportKeyScreen> createState() =>
      _SignedInImportKeyScreenState();
}

class _SignedInImportKeyScreenState extends State<SignedInImportKeyScreen>
    with CustomFlutterToast {
  final SignedInImportKeyBloc _bloc = getIt.get<SignedInImportKeyBloc>();

  bool _passWordIsHide = true;

  final Map<ImportWalletType, String> _options = {
    ImportWalletType.privateKey: AppLocalizationManager.instance.translate(
      LanguageKey.signedInImportKeyScreenSelectTypePrivate,
    ),
    ImportWalletType.passPhrase: AppLocalizationManager.instance.translate(
      LanguageKey.signedInImportKeyScreenSelectTypePassPhrase,
    ),
  };

  final GlobalKey<TextInputNormalIconState> _inputPrivateGlobalKey =
      GlobalKey();
  final GlobalKey<TextInputNormalIconState> _inputPassPhraseGlobalKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<SignedInImportKeyBloc, SignedInImportKeyState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInImportKeyStatus.init:
                  break;
                case SignedInImportKeyStatus.onImportAccountError:
                  AppNavigator.pop();

                  showToast(state.errorMessage!);
                  break;
                case SignedInImportKeyStatus.onImportAccountSuccess:
                  switch (state.pyxisWalletType) {
                    case PyxisWalletType.smartAccount:
                      break;
                    case PyxisWalletType.normalWallet:
                      AppGlobalCubit.of(context).addNewAccount(
                        GlobalActiveAccount(
                          address: state.walletAddress,
                          // Default account name when use import account with normal wallet type.
                          accountName: 'Account 1',
                        ),
                      );
                      break;
                  }
                  AppNavigator.popUntil(
                    RoutePath.home,
                  );
                  break;
                case SignedInImportKeyStatus.onLoading:
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
                                            .signedInImportKeyScreenTitleRegionOne,
                                      ),
                                      style: AppTypoGraPhy.heading06.copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .signedInImportKeyScreenTitleRegionTwo,
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
                            height: BoxSize.boxSize07,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Row(
                                children: [
                                  Text(
                                    localization.translate(
                                      LanguageKey
                                          .signedInImportKeyScreenAccountType,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: BoxSize.boxSize03,
                                  ),
                                  SvgPicture.asset(
                                    AssetIconPath.signedInImportKeyInformation,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize05,
                          ),
                          SignedInImportKeyAccountTypeSelector(
                            builder: (accountType) {
                              return AccountTypeChoiceWidget(
                                onSelected: (selectedAccountType) {
                                  if (selectedAccountType != accountType) {
                                    _bloc.add(
                                      SignedInImportKeyOnSelectAccountTypeEvent(
                                        accountType: selectedAccountType,
                                      ),
                                    );
                                  }
                                },
                                defaultType: accountType,
                                appTheme: appTheme,
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize07,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return SignedInImportKeyImportTypeSelector(
                                builder: (importType) {
                                  return ChoiceSelectWidget<
                                      MapEntry<ImportWalletType, String>>(
                                    data: _options.entries.toList(),
                                    isSelected: (selectedData, compareItem) {
                                      return selectedData
                                          .map((e) => e.key)
                                          .toList()
                                          .contains(compareItem.key);
                                    },
                                    builder: (selectedOptions) {
                                      if (selectedOptions.isEmpty) {
                                        return const SizedBox();
                                      }
                                      return Text(
                                        selectedOptions[0].value,
                                        style: AppTypoGraPhy.body03.copyWith(
                                            color: appTheme.contentColorUnKnow),
                                      );
                                    },
                                    optionBuilder: (option) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option.value,
                                            style: AppTypoGraPhy
                                                .utilityLabelDefault
                                                .copyWith(
                                              color: appTheme.contentColorBlack,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: BoxSize.boxSize03,
                                          ),
                                          Text(
                                            option.value,
                                            style:
                                                AppTypoGraPhy.body02.copyWith(
                                              color: appTheme.contentColor500,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    modalTitle: localization.translate(
                                      LanguageKey
                                          .signedInImportKeyScreenSelectType,
                                    ),
                                    label: localization.translate(
                                      LanguageKey
                                          .signedInImportKeyScreenSelectType,
                                    ),
                                    selectedData: _options.entries
                                        .where((e) => e.key == importType)
                                        .toList(),
                                    onChange: (selectedTypes) {
                                      if (selectedTypes.isNotEmpty) {
                                        final selectedType =
                                            selectedTypes[0].key;

                                        _bloc.add(
                                          SignedInImportKeyOnSelectImportTypeEvent(
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
                          SignedInImportKeyImportTypeSelector(
                            builder: (selectedType) {
                              switch (selectedType) {
                                case ImportWalletType.privateKey:
                                  return AppLocalizationProvider(
                                    builder: (localization, _) {
                                      return TextInputNormalIconWidget(
                                        iconPath: AssetIconPath.commonEyeHide,
                                        isRequired: true,
                                        key: _inputPrivateGlobalKey,
                                        maxLine: 1,
                                        onChanged: (value, isValid) {
                                          if (isValid) {
                                            _bloc.add(
                                              SignedInImportKeyOnInputKeyEvent(
                                                key: value,
                                              ),
                                            );
                                          }
                                        },
                                        constraintManager: ConstraintManager(
                                          isStopWhenFirstFailure: true,
                                          isValidOnChanged: true,
                                        )..custom(
                                            errorMessage:
                                                localization.translate(
                                              LanguageKey
                                                  .signedInImportKeyScreenInvalidPrivateKey,
                                            ),
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
                                              .signedInImportKeyScreenPrivateKey,
                                        ),
                                        obscureText: _passWordIsHide,
                                        onIconTap: () {
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
                                      return TextInputNormalIconWidget(
                                        iconPath: AssetIconPath.commonEyeHide,
                                        isRequired: true,
                                        maxLine: 1,
                                        key: _inputPassPhraseGlobalKey,
                                        onChanged: (value, isValid) {
                                          if (isValid) {
                                            _bloc.add(
                                                SignedInImportKeyOnInputKeyEvent(
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
                                                  .signedInImportKeyScreenInvalidPassPhrase,
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
                                              .signedInImportKeyScreenPassPhrase,
                                        ),
                                        obscureText: _passWordIsHide,
                                        onIconTap: () {
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
                        return SignedInImportKeyIsReadySubmitSelector(
                          builder: (isDisable) {
                            return PrimaryAppButton(
                              text: localization.translate(
                                LanguageKey.signedInImportKeyScreenButtonTitle,
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
                                    const SignedInImportKeyOnSubmitEvent(),
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
        LanguageKey.signedInImportKeyScreenDialogLoadingTitle,
      ),
      appTheme: appTheme,
    );
  }
}
