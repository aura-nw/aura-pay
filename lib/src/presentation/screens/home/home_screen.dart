import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'accounts/accounts_page.dart';
import 'history/history_page.dart';
import 'home/widgets/receive_token_widget.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  late HomeScreenSection currentSection;

  late AnimationController _receiveWidgetController;
  late Animation _receiveAnimation;

  late AppGlobalCubit _appGlobalCubit;

  @override
  void initState() {
    _receiveWidgetController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 450,
      ),
    );
    currentSection = HomeScreenSection.home;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appGlobalCubit = AppGlobalCubit.of(context);
    _receiveAnimation = Tween<double>(
      begin: -context.h,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _receiveWidgetController,
        curve: Curves.easeOutSine,
      ),
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

  void _onReceiveTap(){
    _receiveWidgetController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Stack(
          children: [
            Scaffold(
              body: Stack(
                children: [
                  _buildTab(
                    HomeScreenSection.home,
                    HomePage(
                      onReceiveTap: _onReceiveTap,
                    ),
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
            ),
            AnimatedBuilder(
              animation: _receiveWidgetController,
              child: ReceiveTokenWidget(
                accountName: _appGlobalCubit.state.accounts.first.accountName,
                address: _appGlobalCubit.state.accounts.first.address,
                theme: appTheme,
                onSwipeUp: () async{
                  if (_receiveWidgetController.isCompleted) {
                    await _receiveWidgetController.reverse();

                    _receiveWidgetController.reset();
                  }
                },
                onShareAddress: () {

                },
              ),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    _receiveAnimation.value,
                  ),
                  child: child ?? const SizedBox.shrink(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
