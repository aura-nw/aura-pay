import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'accounts/accounts_page.dart';
import 'history/history_page.dart';
import 'setting/setting_page.dart';
import 'widgets/bottom_navigator_bar_widget.dart';

import 'home/home_page.dart';

enum HomeScreenSection {
  home,
  accounts,
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

  Widget _buildTab(HomeScreenSection section, Widget widget) {
    final active = currentSection == section;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !active,
        child: AnimatedOpacity(
          opacity: active ? 1 : 0,
          duration: const Duration(
            milliseconds: 200,
          ),
          child: widget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          body: Stack(
            children: [
              _buildTab(
                HomeScreenSection.home,
                const HomePage(),
              ),
              _buildTab(
                HomeScreenSection.accounts,
                const AccountsPage(),
              ),
              _buildTab(
                HomeScreenSection.history,
                const HistoryPage(),
              ),
              _buildTab(
                HomeScreenSection.setting,
                const SettingPage(),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigatorBarWidget(
            currentIndex: HomeScreenSection.values.indexOf(
              currentSection,
            ),
            appTheme: appTheme,
            onScanTap: () {},
            onTabSelect: (index) {

              final HomeScreenSection newSection = HomeScreenSection.values[index];

              if(currentSection == newSection){
                return;
              }
              setState(() {
                currentSection = newSection;
              });
            },
          ),
        );
      },
    );
  }
}
