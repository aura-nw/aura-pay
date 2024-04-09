import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/pyxis_wallet_core/pyxis_wallet_helper.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_import_normal_wallet_key/widgets/import_wallet_pass_phrase_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_import_normal_wallet_key/widgets/import_wallet_private_key_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/fill_words_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';
import 'on_boarding_import_normal_wallet_key_bloc.dart';
import 'on_boarding_import_normal_wallet_key_event.dart';
import 'on_boarding_import_normal_wallet_key_selector.dart';
import 'on_boarding_import_normal_wallet_key_state.dart';
import 'widgets/import_wallet_type_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class OnBoardingImportNormalWalletKeyScreen extends StatefulWidget {
  const OnBoardingImportNormalWalletKeyScreen({super.key});

  @override
  State<OnBoardingImportNormalWalletKeyScreen> createState() =>
      _OnBoardingImportNormalWalletKeyScreenState();
}

class _OnBoardingImportNormalWalletKeyScreenState
    extends State<OnBoardingImportNormalWalletKeyScreen>
    with CustomFlutterToast {
  final OnBoardingImportNormalWalletKeyBloc _bloc =
      getIt.get<OnBoardingImportNormalWalletKeyBloc>();

  final Map<ImportWalletType, List<String>> _options = {
    ImportWalletType.privateKey: [
      AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingImportNormalWalletKeyScreenSelectTypePrivateKey,
      ),
      AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingImportNormalWalletKeyScreenPrivateKey,
      ),
    ],
    ImportWalletType.passPhrase12: [
      AppLocalizationManager.instance.translate(
        LanguageKey
            .onBoardingImportNormalWalletKeyScreenSelectTypePassPhrase12Words,
      ),
      AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingImportNormalWalletKeyScreenPassPhrase12Words,
      ),
    ],
    ImportWalletType.passPhrase24: [
      AppLocalizationManager.instance.translate(
        LanguageKey
            .onBoardingImportNormalWalletKeyScreenSelectTypePassPhrase24Words,
      ),
      AppLocalizationManager.instance.translate(
        LanguageKey.onBoardingImportNormalWalletKeyScreenPassPhrase24Words,
      ),
    ],
  };

  final GlobalKey<TextInputNormalSuffixState> _inputPrivateGlobalKey =
      GlobalKey();

  final GlobalKey<FillWordsWidgetState> _passPhrase12FormKey = GlobalKey();

  final GlobalKey<FillWordsWidgetState> _passPhrase24FormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(
          builder: (localization, _) {
            return BlocProvider.value(
              value: _bloc,
              child: BlocListener<OnBoardingImportNormalWalletKeyBloc,
                  OnBoardingImportNormalWalletKeyState>(
                listener: (context, state) {
                  switch (state.status) {
                    case OnBoardingImportNormalWalletKeyStatus.init:
                      break;
                    case OnBoardingImportNormalWalletKeyStatus
                          .onImportAccountError:
                      AppNavigator.pop();

                      showToast(state.errorMessage!);
                      break;
                    case OnBoardingImportNormalWalletKeyStatus
                          .onImportAccountSuccess:
                      AppNavigator.pop();

                      AppGlobalCubit.of(context).changeState(
                        const AppGlobalState(
                          status: AppGlobalStatus.authorized,
                          onBoardingStatus:
                              OnBoardingStatus.importNormalAccountSuccessFul,
                        ),
                      );
                      break;
                    case OnBoardingImportNormalWalletKeyStatus.onLoading:
                      _showLoadingDialog(appTheme);
                      break;
                  }
                },
                child: Scaffold(
                  appBar: NormalAppBarWithTitleWidget(
                    appTheme: appTheme,
                    onViewMoreInformationTap: () {},
                    title: localization.translate(
                      LanguageKey
                          .onBoardingImportNormalWalletKeyScreenAppBarTitle,
                    ),
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
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return OnBoardingImportNormalWalletKeyImportTypeSelector(
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
                                                OnBoardingImportNormalWalletKeyOnSelectImportTypeEvent(
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
                                  height: BoxSize.boxSize07,
                                ),
                                OnBoardingImportNormalWalletKeyImportTypeSelector(
                                  builder: (selectedType) {
                                    switch (selectedType) {
                                      case ImportWalletType.privateKey:
                                        return ImportWalletPrivateKeyWidget(
                                          localization: localization,
                                          appTheme: appTheme,
                                          inPutPrivateKey:
                                              _inputPrivateGlobalKey,
                                          onChanged: (value, isValid) {
                                            _bloc.add(
                                              OnBoardingImportNormalWalletKeyOnInputKeyEvent(
                                                key: value,
                                                isValid: isValid,
                                              ),
                                            );
                                          },
                                          onShowPrivateKey: () {
                                            _bloc.add(
                                              const OnBoardingImportNormalWalletKeyOnChangeShowPrivateKeyEvent(),
                                            );
                                          },
                                          onPaste: _onPastePrivateKey,
                                        );
                                      case ImportWalletType.passPhrase12:
                                        return ImportWalletPassPhraseFormWidget(
                                          appTheme: appTheme,
                                          localization: localization,
                                          wordCount: 12,
                                          onPaste: () {
                                            _onPastePassPhrase(
                                                _passPhrase12FormKey);
                                          },
                                          fillWordKey: _passPhrase12FormKey,
                                          constraintManager: ConstraintManager()
                                            ..custom(
                                              errorMessage:
                                                  localization.translate(
                                                LanguageKey
                                                    .onBoardingImportNormalWalletKeyScreenInvalidPassPhrase,
                                              ),
                                              customValid: (value) {
                                                return PyxisWalletHelper
                                                    .checkMnemonic(
                                                  mnemonic: value,
                                                );
                                              },
                                            ),
                                          onWordChanged: _onPassPhraseChange,
                                        );
                                      case ImportWalletType.passPhrase24:
                                        return ImportWalletPassPhraseFormWidget(
                                          appTheme: appTheme,
                                          localization: localization,
                                          wordCount: 24,
                                          onPaste: () {
                                            _onPastePassPhrase(
                                              _passPhrase24FormKey,
                                            );
                                          },
                                          fillWordKey: _passPhrase24FormKey,
                                          constraintManager: ConstraintManager()
                                            ..custom(
                                              errorMessage:
                                                  localization.translate(
                                                LanguageKey
                                                    .onBoardingImportNormalWalletKeyScreenInvalidPassPhrase,
                                              ),
                                              customValid: (value) {
                                                return PyxisWalletHelper
                                                    .checkMnemonic(
                                                  mnemonic: value,
                                                );
                                              },
                                            ),
                                          onWordChanged: _onPassPhraseChange,
                                        );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize06,
                          ),
                          OnBoardingImportNormalWalletKeyIsReadySubmitSelector(
                            builder: (isDisable) {
                              return PrimaryAppButton(
                                text: localization.translate(
                                  LanguageKey
                                      .onBoardingImportNormalWalletKeyScreenButtonTitle,
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
                                    case ImportWalletType.passPhrase12:
                                      isValid = _passPhrase12FormKey
                                              .currentState
                                              ?.validate() ??
                                          false;
                                      break;

                                    case ImportWalletType.passPhrase24:
                                      isValid = _passPhrase24FormKey
                                              .currentState
                                              ?.validate() ??
                                          false;
                                      break;
                                  }

                                  if (isValid) {
                                    _bloc.add(
                                      const OnBoardingImportNormalWalletKeyOnSubmitEvent(),
                                    );
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
              ),
            );
          },
        );
      },
    );
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.onBoardingImportNormalWalletKeyScreenDialogLoadingTitle,
      ),
      appTheme: appTheme,
    );
  }

  void _onPastePassPhrase(GlobalKey<FillWordsWidgetState> key) async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data != null) {
      key.currentState?.fillWord(data.text ?? '');
    }
  }

  void _onPastePrivateKey() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data != null) {
      _inputPrivateGlobalKey.currentState?.setValue(data.text ?? '');
    }
  }

  void _onPassPhraseChange(String value, bool isValid) {
    _bloc.add(
      OnBoardingImportNormalWalletKeyOnInputKeyEvent(
        key: value,
        isValid: isValid,
      ),
    );
  }
}
