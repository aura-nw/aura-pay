import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/presentation/screens/create_passcode/create_passcode_cubit.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';
import 'package:pyxis_v2/src/presentation/widgets/input_password_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/key_board_number_widget.dart';

class CreatePasscodeScreen extends StatefulWidget {
  const CreatePasscodeScreen({super.key});

  @override
  State<CreatePasscodeScreen> createState() => _CreatePasscodeScreenState();
}

class _CreatePasscodeScreenState extends State<CreatePasscodeScreen>
    with StateFulBaseScreen, SingleTickerProviderStateMixin {

  final CreatePasscodeCubit _cubit =
  getIt.get<CreatePasscodeCubit>();

  late PageController _pageController;

  int _fillIndex = -1;

  final List<String> _password = [];
  final List<String> _confirmPassword = [];

  bool _wrongConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              InputPasswordWidget(
                length: 6,
                appTheme: appTheme,
                fillIndex: _fillIndex,
              ),
              InputPasswordWidget(
                length: 6,
                appTheme: appTheme,
                fillIndex: _fillIndex,
              ),
            ],
          ),
        ),
        KeyboardNumberWidget(
          rightButtonFn: _onClearPassword,
          onKeyboardTap: _onKeyBoardTap,
        ),
      ],
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: child,
      ),
    );
  }

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

  void _onKeyBoardTap(String text) async {
    if (_pageController.page == 0) {
      /// create password
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
      /// confirm password
      _fillIndex++;

      _confirmPassword.add(text);
      if (_fillIndex == 5) {
        if (_confirmPassword.join() != _password.join()) {
          /// show unMatch wrong
          _wrongConfirmPassword = true;
        } else {
          _wrongConfirmPassword = false;
        }

        String passWord = _password.join();

        if (_wrongConfirmPassword) {
          setState(() {});

          return;
        }

        await _cubit.savePasscode(passWord);
      }
    }
    setState(() {});
  }

  void _onSavePassWordDone() {

  }
}
