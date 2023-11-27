import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_page/home_page.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/widgets/bottom_navigator_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return  Scaffold(
          body: const HomePage(),
          bottomNavigationBar: BottomNavigatorBarWidget(
            appTheme: appTheme,
          ),
        );
      },
    );
  }
}
