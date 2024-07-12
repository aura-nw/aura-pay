import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/presentation/screens/home/browser/browser_page.dart';
import 'package:pyxis_v2/src/presentation/screens/home/history/history_page.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home/home_page.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home_screen.dart';
import 'package:pyxis_v2/src/presentation/screens/home/setting/setting_page.dart';
import 'package:pyxis_v2/src/presentation/screens/home/wallet/wallet_page.dart';

class HomeScreenTabBuilder extends StatelessWidget {
  final HomeScreenSection currentSection;

  const HomeScreenTabBuilder({
    required this.currentSection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(currentSection);
    return Stack(
      children: [
        _buildTab(
          HomeScreenSection.wallet,
          const WalletPage(),
        ),
        _buildTab(
          HomeScreenSection.browser,
          const BrowserPage(),
        ),
        _buildTab(
          HomeScreenSection.home,
          const HomePage(),
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
