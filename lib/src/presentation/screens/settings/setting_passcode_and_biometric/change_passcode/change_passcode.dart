import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/input_password_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/key_board_number_widget.dart';

// Define a class named ChangePassCodePage that extends StatefulWidget
class ChangePassCodePage extends StatefulWidget {
  const ChangePassCodePage({super.key});

  // Override the createState method to create the state for this widget
  @override
  State<ChangePassCodePage> createState() => _ChangePassCodePageState();
}

// Define a private class named _ChangePassCodePageState that extends the State class
class _ChangePassCodePageState extends State<ChangePassCodePage> {
  // Define variables
  int _fillIndex = -1;
  final PageController _pageController = PageController();
  final List<String> _password = [];
  final List<String> _confirmPassword = [];
  bool _wrongConfirmPassword = false;

  // Build the widget tree for this stateful widget
  @override
  Widget build(BuildContext context) {
    // Use AppThemeBuilder to provide the app theme to the widget tree
    return AppThemeBuilder(builder: (appTheme) {
      // Return a Scaffold widget with the app theme and other widgets
      return Scaffold(
        backgroundColor: appTheme.bodyColorBackground,
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildEnterPasscodePage(appTheme),
                    _buildCreatePasscodePage(appTheme),
                    _buildConfirmPasscodePage(appTheme),
                  ],
                ),
              ),
              // Display the keyboard number widget
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
      );
    });
  }

  // Method to build the confirm passcode page
  Widget _buildEnterPasscodePage(AppTheme appTheme) {
    return Column(
      children: [
        // Display the title for confirming the passcode
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.settingChangePasscodePageEnterYourPassword,
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
        // Display the input password widget for confirmation
        InputPasswordWidget(
          length: 6,
          appTheme: appTheme,
          fillIndex: _fillIndex,
        ),
        // Display an error message if the confirmation password does not match
        if (_wrongConfirmPassword) ...[
          const SizedBox(
            height: Spacing.spacing04,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.onBoardingSetupPasscodeScreenConfirmNotMatch,
                ),
                style: AppTypoGraPhy.utilityHelperSm.copyWith(
                  color: appTheme.contentColorDanger,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ] else
          const SizedBox()
      ],
    );
  }

  // Method to build the confirm passcode page
  Widget _buildConfirmPasscodePage(AppTheme appTheme) {
    return Column(
      children: [
        // Display the title for confirming the passcode
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.onBoardingSetupPasscodeScreenConfirmTitle,
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
        // Display the input password widget for confirmation
        InputPasswordWidget(
          length: 6,
          appTheme: appTheme,
          fillIndex: _fillIndex,
        ),
        // Display an error message if the confirmation password does not match
        if (_wrongConfirmPassword) ...[
          const SizedBox(
            height: Spacing.spacing04,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.onBoardingSetupPasscodeScreenConfirmNotMatch,
                ),
                style: AppTypoGraPhy.utilityHelperSm.copyWith(
                  color: appTheme.contentColorDanger,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ] else
          const SizedBox()
      ],
    );
  }

  // Method to build the create passcode page
  Widget _buildCreatePasscodePage(AppTheme appTheme) {
    return Column(
      children: [
        // Display the title for creating a passcode
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.onBoardingSetupPasscodeScreenCreateTitle,
              ),
              style: AppTypoGraPhy.bodyMedium04.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: Spacing.spacing04,
        ),
        // Display the content for creating a passcode
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.onBoardingSetupPasscodeScreenCreateContent,
              ),
              style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
        const SizedBox(
          height: Spacing.spacing10,
        ),
        // Display the input password widget
        InputPasswordWidget(
          length: 6,
          appTheme: appTheme,
          fillIndex: _fillIndex,
        ),
      ],
    );
  }

  // Method to clear the password
  void _onClearPassword() {
    if (_fillIndex < 0) return;

    _fillIndex--;

    if (_pageController.page == 0) {
      if (_password.isEmpty) return;
      _password.removeLast();
    } else {
      if (_confirmPassword.isEmpty) return;
      _confirmPassword.removeLast();
    }

    setState(() {});
  }

  // Method to handle keyboard tap
  void _onKeyBoardTap(String text) async {
    if (_pageController.page == 0) {
      // Create password
      _fillIndex++;
      _password.add(text);

      if (_fillIndex == 5) {
        _fillIndex = -1;
        _pageController.animateToPage(
          1,
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.bounceIn,
        );
      }
    } else {
      // Confirm password
      _fillIndex++;
      _confirmPassword.add(text);

      if (_fillIndex == 5) {
        if (_confirmPassword.join() != _password.join()) {
          // Show an error message if the confirmation password does not match
          _wrongConfirmPassword = true;
        } else {
          _wrongConfirmPassword = false;
        }

        String passWord = _password.join();

        if (_wrongConfirmPassword) {
          setState(() {});
          return;
        }

        // await _bloc.onSavePassCode(passWord);
      }
    }
    setState(() {});
  }

  void _onSavePassWordDone() {
    _fillIndex = -1;

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

    _pageController.animateToPage(
      1,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.bounceIn,
    );

    _confirmPassword.clear();

    _password.clear();
  }
}
