import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/navigator.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

final class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with StateFulBaseScreen {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(const Duration(seconds: 2)).then(
          (value) {
            AppNavigator.push(RoutePath.getStarted);
          },
        );
      },
    );
  }

  @override
  Widget child(BuildContext context,AppTheme appTheme, AppLocalizationManager localization) {
    return const Center(
      child: Text('Splash screen'),
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child,AppTheme appTheme, AppLocalizationManager localization) {
    return Scaffold(
      body: child,
    );
  }
}
