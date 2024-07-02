import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with StateFulBaseScreen {
  @override
  Widget child(BuildContext context, AppTheme appTheme, AppLocalizationManager localization) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryAppButton(
            text: 'Create',
            onPress: () {

            },
          ),
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          PrimaryAppButton(
            text: 'Import',
            onPress: () {

            },
          ),
        ],
      ),
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme, AppLocalizationManager localization) {
    return Scaffold(
      body: child,
    );
  }
}
