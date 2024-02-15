import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryAppButton(
                text: 'Click',
                onPress: () {
                  AppNavigator.push(
                    RoutePath.browser,
                    'https://google.com'
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
