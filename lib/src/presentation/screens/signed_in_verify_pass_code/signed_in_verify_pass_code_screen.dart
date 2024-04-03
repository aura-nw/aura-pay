import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'signed_in_verify_passcode_state.dart';
import 'signed_in_verify_passcode_cubit.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/input_password_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/key_board_number_widget.dart';

class SignedInVerifyPasscodeScreen extends StatefulWidget {
  final VoidCallback onVerifySuccessful;

  const SignedInVerifyPasscodeScreen({
    required this.onVerifySuccessful,
    super.key,
  });

  @override
  State<SignedInVerifyPasscodeScreen> createState() =>
      _SignedInVerifyPasscodeScreenState();
}

class _SignedInVerifyPasscodeScreenState
    extends State<SignedInVerifyPasscodeScreen> {
  int _fillIndex = -1;

  //user input password
  final List<String> _passwords = List.empty(growable: true);

  final SignedInVerifyPasscodeCubit _cubit =
      getIt.get<SignedInVerifyPasscodeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SignedInVerifyPasscodeCubit,SignedInVerifyPasscodeStatus>(
        listener: (context, state) {
          switch(state){
            case SignedInVerifyPasscodeStatus.none:
              break;
            case SignedInVerifyPasscodeStatus.verifyNotMatch:
              break;
            case SignedInVerifyPasscodeStatus.verifySuccess:
              widget.onVerifySuccessful();
              break;
          }
        },
        child: AppThemeBuilder(
          builder: (appTheme) {
            return Scaffold(
              appBar: AppBarWithTitle(
                titleKey: '',
                appTheme: appTheme,
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
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              AssetIconPath.onBoardingSetupPasscodeLock,
                            ),
                            const SizedBox(
                              height: Spacing.spacing05,
                            ),
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(
                                    LanguageKey.signedInVerifyPasscodeScreenTitle,
                                  ),
                                  style: AppTypoGraPhy.heading02.copyWith(
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
                            BlocBuilder<SignedInVerifyPasscodeCubit,
                                SignedInVerifyPasscodeStatus>(
                              builder: (context, state) {
                                if (state ==
                                    SignedInVerifyPasscodeStatus.verifyNotMatch) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: Spacing.spacing04,
                                      ),
                                      AppLocalizationProvider(
                                        builder: (localization, _) {
                                          return Text(
                                            localization.translate(
                                              LanguageKey
                                                  .signedInVerifyPasscodeScreenPasscodeNotMatch,
                                            ),
                                            style: AppTypoGraPhy.utilityHelperSm
                                                .copyWith(
                                              color: appTheme.contentColorDanger,
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
                      ),
                      KeyboardNumberWidget(
                        onKeyboardTap: _onFillPassword,
                        rightButtonFn: _onClearPassword,
                        rightIcon: SvgPicture.asset(
                          AssetIconPath.commonClear,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onFillPassword(String text) {
    if (_fillIndex == 5) return;

    _passwords.add(text);

    _fillIndex++;

    setState(() {});

    if (_fillIndex == 5) {
      _cubit.onVerifyPasscode(
        _passwords.join(),
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
