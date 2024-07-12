import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_v2/src/application/global/localization/app_localization_provider.dart';

import 'widgets/bottom_navigator_bar_widget.dart';
import 'widgets/tab_builder.dart';

enum HomeScreenSection {
  wallet,
  browser,
  home,
  history,
  setting,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late HomeScreenSection currentSection;

  @override
  void initState() {
    currentSection = HomeScreenSection.home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppThemeBuilder(
        builder: (appTheme) {
          return AppLocalizationProvider(
            builder: (localization) {
              return Scaffold(
                body: SafeArea(
                  child: HomeScreenTabBuilder(
                    currentSection: currentSection,
                  ),
                ),
                bottomNavigationBar: BottomNavigatorBarWidget(
                  currentIndex: HomeScreenSection.values.indexOf(
                    currentSection,
                  ),
                  appTheme: appTheme,
                  onTabSelect: (index) {
                    // Handle tab selection and update the current section
                    final HomeScreenSection newSection =
                    HomeScreenSection.values[index];

                    if (currentSection == newSection) {
                      return;
                    }
                    setState(() {
                      currentSection = newSection;
                    });
                  }, localization: localization,
                ),
              );
            }
          );
        }
      ),
    );
  }
}
