import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_re_login/widgets/forgot_passcode_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'on_boarding_re_login_bloc.dart';
import 'on_boarding_re_login_event.dart';
import 'on_boarding_re_login_selector.dart';
import 'on_boarding_re_login_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/input_password_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/key_board_number_widget.dart';

class OnBoardingReLoginScreen extends StatefulWidget {
  const OnBoardingReLoginScreen({super.key});

  @override
  State<OnBoardingReLoginScreen> createState() =>
      _OnBoardingReLoginScreenState();
}

class _OnBoardingReLoginScreenState extends State<OnBoardingReLoginScreen> {
  final OnBoardingReLoginBloc _bloc = getIt.get<OnBoardingReLoginBloc>();

  int _fillIndex = -1;

  //user input password
  final List<String> _passwords = List.empty(growable: true);

  Timer? _lockTimer;
  int _time = 120;

  void _onStartCountDownTimer() {
    _resetPasswordWhenLockTime();
    _lockTimer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) {
        _time--;

        setState(() {});

        if (_time == 0) {
          _resetLockTime();
          _bloc.add(
            const OnBoardingReLoginEventOnUnLockInputPassword(),
          );
        }
      },
    );
  }

  void _resetLockTime() {
    _lockTimer?.cancel();
    _time = 120;
  }

  void _resetPasswordWhenLockTime() {
    _passwords.clear();
    _fillIndex = -1;

    setState(() {});
  }

  @override
  void dispose() {
    _resetLockTime();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<OnBoardingReLoginBloc, OnBoardingReLoginState>(
            listener: (context, state) {
              switch (state.status) {
                case OnBoardingReLoginStatus.none:
                  break;
                case OnBoardingReLoginStatus.hasAccounts:
                  AppGlobalCubit.of(context).changeState(
                    const AppGlobalState(
                      status: AppGlobalStatus.authorized,
                    ),
                  );
                  break;

                case OnBoardingReLoginStatus.nonHasAccounts:
                  AppNavigator.replaceWith(
                    RoutePath.choiceOption,
                    false,
                  );
                  break;
                case OnBoardingReLoginStatus.wrongPassword:
                  break;
                case OnBoardingReLoginStatus.lockTime:
                  _onStartCountDownTimer();
                  break;
              }
            },
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing08,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: BoxSize.boxSize13,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            AssetLogoPath.logo,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize05,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translate(
                                  LanguageKey.onBoardingReLoginScreenTitle,
                                ),
                                style: AppTypoGraPhy.heading04.copyWith(
                                  color: appTheme.contentColorBlack,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize08,
                          ),
                          InputPasswordWidget(
                            length: 6,
                            appTheme: appTheme,
                            fillIndex: _fillIndex,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize08,
                          ),
                          OnBoardingReLoginStatusSelector(
                            builder: (status) {
                              switch (status) {
                                case OnBoardingReLoginStatus.none:
                                case OnBoardingReLoginStatus.hasAccounts:
                                case OnBoardingReLoginStatus.nonHasAccounts:
                                  return const SizedBox.shrink();
                                case OnBoardingReLoginStatus.lockTime:
                                  return AppLocalizationProvider(
                                    builder: (localization, _) {
                                      return Text(
                                        localization.translateWithParam(
                                          LanguageKey
                                              .onBoardingReLoginScreenWrongCountDownTitle,
                                          {
                                            'time':
                                                '${_time.toMinutes}:${_time.toSeconds}',
                                          },
                                        ),
                                        style: AppTypoGraPhy.utilityHelperSm
                                            .copyWith(
                                          color: appTheme.contentColorDanger,
                                        ),
                                      );
                                    },
                                  );
                                case OnBoardingReLoginStatus.wrongPassword:
                                  return AppLocalizationProvider(
                                    builder: (localization, _) {
                                      return Text(
                                        localization.translate(
                                          LanguageKey
                                              .onBoardingReLoginScreenWrongPassword,
                                        ),
                                        style: AppTypoGraPhy.utilityHelperSm
                                            .copyWith(
                                          color: appTheme.contentColorDanger,
                                        ),
                                      );
                                    },
                                  );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize08,
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return RichText(
                          text: TextSpan(
                            text: localization.translate(
                              LanguageKey.onBoardingReLoginScreenForgetPassword,
                            ),
                            style: AppTypoGraPhy.body02.copyWith(
                              color: appTheme.contentColorBrand,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                AppBottomSheetLayout.showFullScreenDialog(
                                  context,
                                  child: const ForgotPasscodeFormWidget(),
                                );
                              },
                          ),
                        );
                      },
                    ),
                    OnBoardingReLoginStatusSelector(
                      builder: (status) {
                        bool isLockIn =
                            status == OnBoardingReLoginStatus.lockTime;
                        return KeyboardNumberWidget(
                          onKeyboardTap: (text) {
                            if (isLockIn) return;

                            _onFillPassword(text);
                          },
                          rightButtonFn: () {
                            if (isLockIn) return;

                            _onClearPassword();
                          },
                          rightIcon: SvgPicture.asset(
                            AssetIconPath.commonClear,
                          ),
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

  void _onFillPassword(String text) {
    if (_fillIndex == 5) return;

    _passwords.add(text);

    _fillIndex++;

    setState(() {});

    if (_fillIndex == 5) {
      _bloc.add(
        OnBoardingReLoginEventOnInputPassword(
          _passwords.join(),
        ),
      );
    }
  }

  void _onClearPassword() {
    if (_fillIndex < 0) return;

    _fillIndex--;

    if (_passwords.isEmpty) return;
    _passwords.removeLast();

    setState(() {});
  }
}
