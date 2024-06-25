import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/browser/browser_page.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/history_page.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home/home_page.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/setting/setting_page.dart';

class HomeScreenTabBuilder extends StatelessWidget {
  final HomeScreenSection currentSection;
  final VoidCallback onReceiveTap;

  const HomeScreenTabBuilder({
    required this.currentSection,
    super.key,
    required this.onReceiveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildTab(
          HomeScreenSection.home,
          HomePage(
            onReceiveTap: onReceiveTap,
          ),
        ),
        _buildTab(
          HomeScreenSection.browser,
          const BrowserPage(),
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
    );
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
}
