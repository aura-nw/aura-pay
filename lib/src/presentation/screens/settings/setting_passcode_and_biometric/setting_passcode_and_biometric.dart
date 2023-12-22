import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/setting/widgets/setting_option_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

class SettingPagePasscode extends StatefulWidget {
  const SettingPagePasscode({super.key});

  @override
  State<SettingPagePasscode> createState() => _SettingPagePasscodeState();
}

class _SettingPagePasscodeState extends State<SettingPagePasscode> {
  int _fillIndex = -1;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: AppBarWithOnlyTitle(
            appTheme: appTheme,
            titleKey: LanguageKey.settingChangePasscodeScreenAppBarTitle,
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: BoxSize.boxSize04,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                ),
                child: Column(
                  children: [
                    SettingOptionWidget(
                      iconPath: AssetIconPath.settingBiometric,
                      labelPath:
                          LanguageKey.settingChangePasscodeScreenChangePasscode,
                      appTheme: appTheme,
                      onTap: () {
                        AppNavigator.push(
                          RoutePath.setting_change_passcode,
                        );
                      },
                    ),
                    SettingOptionWidget(
                      iconPath: AssetIconPath.settingDeviceManagement,
                      labelPath: LanguageKey.settingChangePasscodeScreenFaceId,
                      appTheme: appTheme,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const HoLiZonTalDividerWidget(),
              const SizedBox(
                height: BoxSize.boxSize07,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                ),
                child: SettingOptionWidget(
                  iconPath: AssetIconPath.settingHelpCenter,
                  labelPath: LanguageKey.settingPageHelpCenter,
                  appTheme: appTheme,
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onClearPassword() {
    // if (_fillIndex < 0) return;

    // _fillIndex--;

    // if(_pageController.page == 0){

    //   if(_password.isEmpty) return;
    //   _password.removeLast();
    // }else{

    //   if(_confirmPassword.isEmpty) return;
    //   _confirmPassword.removeLast();
    // }

    // setState(() {});
  }

  void _onKeyBoardTap(String text) async {
    // if (_pageController.page == 0) {
    //   /// create password
    //   _fillIndex++;

    //   _password.add(text);

    //   if (_fillIndex == 5) {
    //     _fillIndex = -1;
    //     _pageController.animateToPage(
    //       1,
    //       duration: const Duration(
    //         milliseconds: 300,
    //       ),
    //       curve: Curves.bounceIn,
    //     );
    //   }
    // } else {
    //   /// confirm password
    //   _fillIndex++;

    //   _confirmPassword.add(text);
    //   if (_fillIndex == 5) {
    //     if (_confirmPassword.join() != _password.join()) {
    //       /// show unMatch wrong
    //       _wrongConfirmPassword = true;
    //     } else {
    //       _wrongConfirmPassword = false;
    //     }

    //     String passWord = _password.join();

    //     if(_wrongConfirmPassword) {
    //       setState(() {});

    //       return;
    //     }

    //     await _bloc.onSavePassCode(passWord);
    //   }
    // }
    // setState(() {});
  }

  void _onSavePassWordDone() {
    // _fillIndex = -1;

    // switch (widget.onboardingType) {
    //   case OnboardingType.create:
    //     AppNavigator.push(
    //       RoutePath.pickAccountName,
    //     );
    //     break;
    //   case OnboardingType.import:
    //     AppNavigator.push(
    //       RoutePath.importFirstPage,
    //     );
    //     break;
    //   case OnboardingType.recover:
    //     AppNavigator.push(
    //       RoutePath.recoverChoice,
    //     );
    //     break;
    // }

    // _pageController.animateToPage(
    //   1,
    //   duration: const Duration(
    //     milliseconds: 300,
    //   ),
    //   curve: Curves.bounceIn,
    // );

    // _confirmPassword.clear();

    // _password.clear();
  }
}
