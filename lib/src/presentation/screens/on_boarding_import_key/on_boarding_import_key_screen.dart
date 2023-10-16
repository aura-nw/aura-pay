import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/choice_select_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

import 'widgets/acocunt_type_widget.dart';

class OnBoardingImportKeyScreen extends StatefulWidget {
  final String passWord;

  const OnBoardingImportKeyScreen({required this.passWord, super.key});

  @override
  State<OnBoardingImportKeyScreen> createState() =>
      _OnBoardingImportKeyScreenState();
}

class _OnBoardingImportKeyScreenState extends State<OnBoardingImportKeyScreen> {
  bool _passWordIsHide = true;

  /// Default import type
  ImportWalletType type = ImportWalletType.privateKey;

  final Map<ImportWalletType, String> _options = {
    ImportWalletType.privateKey: AppLocalizationManager.instance.translate(
      LanguageKey.onBoardingImportKeyScreenSelectTypePrivate,
    ),
    ImportWalletType.passPhrase: AppLocalizationManager.instance.translate(
      LanguageKey.onBoardingImportKeyScreenSelectTypePassPhrase,
    ),
  };

  final GlobalKey<TextInputNormalIconState> _inputPrivateGlobalKey =
      GlobalKey();
  final GlobalKey<TextInputNormalIconState> _inputPassPhraseGlobalKey =
      GlobalKey();

  final List<MapEntry<ImportWalletType, String>> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
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
                      const SizedBox(
                        height: BoxSize.boxSize07,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, p1) {
                          return Row(
                            children: [
                              Text(
                                localization.translate(
                                  LanguageKey
                                      .onBoardingImportKeyScreenAccountType,
                                ),
                              ),
                              const SizedBox(
                                width: BoxSize.boxSize03,
                              ),
                              SvgPicture.asset(
                                AssetIconPath.onBoardingImportKeyInformation,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize05,
                      ),
                      AccountTypeChoiceWidget(
                        onSelected: (index) {},
                        appTheme: appTheme,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize07,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return ChoiceSelectWidget<
                              MapEntry<ImportWalletType, String>>(
                            data: _options.entries.toList(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.value,
                                    style: AppTypoGraPhy.utilityLabelDefault
                                        .copyWith(
                                      color: appTheme.contentColorBlack,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: BoxSize.boxSize03,
                                  ),
                                  Text(
                                    option.value,
                                    style: AppTypoGraPhy.body02.copyWith(
                                      color: appTheme.contentColor500,
                                    ),
                                  ),
                                ],
                              );
                            },
                            modalTitle: localization.translate(
                              LanguageKey.onBoardingImportKeyScreenSelectType,
                            ),
                            label: localization.translate(
                              LanguageKey.onBoardingImportKeyScreenSelectType,
                            ),
                            selectedData: _selectedOptions,
                            onChange: _onSelectTypeChange,
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize05,
                      ),
                      type == ImportWalletType.privateKey
                          ? AppLocalizationProvider(
                              builder: (localization, _) {
                                return TextInputNormalIconWidget(
                                  iconPath: AssetIconPath.commonEyeHide,
                                  isRequired: true,
                                  key: _inputPrivateGlobalKey,
                                  maxLine: 1,
                                  constraintManager: ConstraintManager(
                                    isStopWhenFirstFailure: true,
                                    isValidOnChanged: true,
                                  )..custom(
                                      errorMessage: localization.translate(
                                          LanguageKey
                                              .onBoardingImportKeyScreenInvalidPrivateKey),
                                      customValid: (value) {
                                        return false;
                                      },
                                    ),
                                  label: localization.translate(
                                    LanguageKey
                                        .onBoardingImportKeyScreenPrivateKey,
                                  ),
                                  obscureText: _passWordIsHide,
                                  onIconTap: () {
                                    setState(() {
                                      _passWordIsHide = !_passWordIsHide;
                                    });
                                  },
                                );
                              },
                            )
                          : AppLocalizationProvider(
                              builder: (localization, _) {
                                return TextInputNormalIconWidget(
                                  iconPath: AssetIconPath.commonEyeHide,
                                  isRequired: true,
                                  maxLine: 1,
                                  key: _inputPassPhraseGlobalKey,
                                  constraintManager: ConstraintManager(
                                    isStopWhenFirstFailure: true,
                                    isValidOnChanged: false,
                                  )..custom(
                                      errorMessage: localization.translate(
                                        LanguageKey
                                            .onBoardingImportKeyScreenInvalidPassPhrase,
                                      ),
                                      customValid: (value) {
                                        return false;
                                      },
                                    ),
                                  label: localization.translate(
                                    LanguageKey
                                        .onBoardingImportKeyScreenPassPhrase,
                                  ),
                                  obscureText: _passWordIsHide,
                                  onIconTap: () {
                                    setState(() {
                                      _passWordIsHide = !_passWordIsHide;
                                    });
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey.onBoardingImportKeyScreenButtonTitle,
                      ),
                      onPress: () {
                        switch (type) {
                          case ImportWalletType.privateKey:
                            bool isValid = _inputPrivateGlobalKey.currentState
                                    ?.validate() ??
                                false;

                            if (isValid) {}
                            break;
                          case ImportWalletType.passPhrase:
                            bool isValid = _inputPassPhraseGlobalKey
                                    .currentState
                                    ?.validate() ??
                                false;

                            if (isValid) {}
                            break;
                        }
                      },
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

  void _onSelectTypeChange(
      List<MapEntry<ImportWalletType, String>> selectedData) {
    if (selectedData.isEmpty) return;

    _selectedOptions.clear();

    _selectedOptions.addAll(selectedData);

    setState(() {
      type = selectedData[0].key;
    });
  }
}
