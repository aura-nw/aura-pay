import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'setting_change_passcode_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/input_password_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/key_board_number_widget.dart';

import 'setting_change_passcode_cubit.dart';
import 'setting_change_passcode_selector.dart';

class SettingChangePasscodeScreen extends StatefulWidget {
  const SettingChangePasscodeScreen({super.key});

  @override
  State<SettingChangePasscodeScreen> createState() =>
      _SettingChangePasscodeScreenState();
}

class _SettingChangePasscodeScreenState
    extends State<SettingChangePasscodeScreen> {
  final SettingChangePasscodeCubit _cubit =
      getIt.get<SettingChangePasscodeCubit>();
  int _fillIndex = -1;

  final PageController _pageController = PageController();

  final List<String> _password = [];

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocListener<SettingChangePasscodeCubit,
              SettingChangePasscodeState>(
            listener: (context, state) {
              switch (state.status) {
                case SettingChangePassCodeStatus.none:
                  break;
                case SettingChangePassCodeStatus.enterPasscodeSuccessful:
                  // Create this cache passcode
                  _onClearPassCode();
                  // Move to create page
                  _onMoveToNextPage(1);
                  break;
                case SettingChangePassCodeStatus.enterPasscodeWrong:
                  break;
                case SettingChangePassCodeStatus.createNewPassCodeDone:
                  // Create this cache passcode
                  _onClearPassCode();
                  // Move to confirm page
                  _onMoveToNextPage(2);
                  break;
                case SettingChangePassCodeStatus.confirmPasscodeWrong:
                  break;
                case SettingChangePassCodeStatus.confirmPassCodeSuccessful:
                  AppNavigator.pop(true);
                  break;
              }
            },
            child: Scaffold(
              backgroundColor: appTheme.bodyColorBackground,
              appBar: NormalAppBarWidget(
                appTheme: appTheme,
                onViewMoreInformationTap: () {},
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.spacing07,
                      ),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              AppLocalizationProvider(
                                builder: (localization, _) {
                                  return Text(
                                    localization.translate(
                                      LanguageKey
                                          .settingChangePasscodeScreenEnterYourPassword,
                                    ),
                                    style: AppTypoGraPhy.bodyMedium04.copyWith(
                                      color: appTheme.contentColorBlack,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: Spacing.spacing10,
                              ),
                              InputPasswordWidget(
                                length: 6,
                                appTheme: appTheme,
                                fillIndex: _fillIndex,
                              ),
                              SettingChangePasscodeStatusSelector(
                                builder: (status) {
                                  if (status ==
                                      SettingChangePassCodeStatus
                                          .enterPasscodeWrong) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: Spacing.spacing04,
                                        ),
                                        AppLocalizationProvider(
                                          builder: (localization, _) {
                                            return Text(
                                              localization.translate(
                                                LanguageKey
                                                    .settingChangePasscodeScreenInputPasscodeInvalid,
                                              ),
                                              style: AppTypoGraPhy
                                                  .utilityHelperSm
                                                  .copyWith(
                                                color:
                                                    appTheme.contentColorDanger,
                                              ),
                                              textAlign: TextAlign.center,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              AppLocalizationProvider(
                                builder: (localization, _) {
                                  return Text(
                                    localization.translate(
                                      LanguageKey
                                          .settingChangePasscodeScreenCreateNewPasscode,
                                    ),
                                    style: AppTypoGraPhy.bodyMedium04.copyWith(
                                      color: appTheme.contentColorBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: Spacing.spacing04,
                              ),
                              AppLocalizationProvider(
                                builder: (localization, _) {
                                  return Text(
                                    localization.translate(
                                      LanguageKey
                                          .settingChangePasscodeScreenCreateNewPasscodeContent,
                                    ),
                                    style: AppTypoGraPhy.utilityLabelSm
                                        .copyWith(
                                      color: appTheme.contentColor500,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: Spacing.spacing10,
                              ),
                              InputPasswordWidget(
                                length: 6,
                                appTheme: appTheme,
                                fillIndex: _fillIndex,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              AppLocalizationProvider(
                                builder: (localization, _) {
                                  return Text(
                                    localization.translate(
                                      LanguageKey
                                          .settingChangePasscodeScreenConfirmPassCode,
                                    ),
                                    style: AppTypoGraPhy.bodyMedium04.copyWith(
                                      color: appTheme.contentColorBlack,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: Spacing.spacing10,
                              ),
                              InputPasswordWidget(
                                length: 6,
                                appTheme: appTheme,
                                fillIndex: _fillIndex,
                              ),
                              SettingChangePasscodeStatusSelector(
                                builder: (status) {
                                  if (status ==
                                      SettingChangePassCodeStatus
                                          .confirmPasscodeWrong) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: Spacing.spacing04,
                                        ),
                                        AppLocalizationProvider(
                                          builder: (localization, _) {
                                            return Text(
                                              localization.translate(
                                                LanguageKey
                                                    .settingChangePasscodeScreenConfirmPassCodeInvalid,
                                              ),
                                              style: AppTypoGraPhy
                                                  .utilityHelperSm
                                                  .copyWith(
                                                color:
                                                    appTheme.contentColorDanger,
                                              ),
                                              textAlign: TextAlign.center,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  KeyboardNumberWidget(
                    rightIcon: SvgPicture.asset(
                      AssetIconPath.commonClear,
                    ),
                    rightButtonFn: _onClearPassword,
                    onKeyboardTap: _onKeyBoardTap,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onMoveToNextPage(int page) async {
    _pageController.animateToPage(
      page,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.bounceIn,
    );
  }

  void _onClearPassword() {
    if (_fillIndex < 0) return;

    _fillIndex--;

    if (_password.isEmpty) return;
    _password.removeLast();

    setState(() {});
  }

  void _onKeyBoardTap(String text) async {
    double? currentPage = _pageController.page;

    _fillIndex++;

    setState(() {});

    _password.add(text);

    VoidCallback callBack;

    if (currentPage == 0) {
      /// Enter passcode

      callBack = _onEnterPassCode;
    } else if (currentPage == 1) {
      callBack = _onCreatePassCode;
    } else {
      callBack = _onConfirmPassCode;
    }

    if (_fillIndex == 5) {
      callBack.call();
    }
  }

  void _onClearPassCode() {
    _fillIndex = -1;
    _password.clear();
    setState(() {});
  }

  void _onEnterPassCode() {
    _cubit.onEnterPasscodeDone(_password);
  }

  void _onCreatePassCode() {
    _cubit.onCreatePassCodeDone(_password);
  }

  void _onConfirmPassCode() {
    _cubit.onConfirmPassCodeDone(_password);
  }
}
