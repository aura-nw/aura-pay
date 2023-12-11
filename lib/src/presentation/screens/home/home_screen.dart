import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/helpers/share_network.dart';
import 'package:pyxis_mobile/src/core/helpers/system_permission_helper.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'accounts/accounts_page.dart';
import 'history/history_page.dart';
import 'home/widgets/receive_token_widget.dart';
import 'home_screen_bloc.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomeScreenSection currentSection;

  late AnimationController _receiveWidgetController;
  late Animation _receiveAnimation;

  final HomeScreenBloc _bloc = getIt.get<HomeScreenBloc>();

  @override
  void initState() {
    _bloc.add(
      const HomeScreenEventOnInit(),
    );
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

  void _onReceiveTap() {
    _receiveWidgetController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: HomeScreenStatusSelector(
            builder: (status) {
              switch (status) {
                case HomeScreenStatus.loading:
                  return Center(
                    child: AppLoadingWidget(
                      appTheme: appTheme,
                    ),
                  );
                case HomeScreenStatus.loaded:
                case HomeScreenStatus.error:
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
                          onScanTap: () {
                            _showRequestCameraPermission(
                              appTheme,
                            );
                          },
                          onTabSelect: (index) {
                            final HomeScreenSection newSection =
                                HomeScreenSection.values[index];

                            if (currentSection == newSection) {
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
                        child: HomeScreenAccountsSelector(
                          builder: (accounts) {
                            final account = accounts.first;
                            return ReceiveTokenWidget(
                              accountName: account.name,
                              address: account.address,
                              theme: appTheme,
                              onSwipeUp: () async {
                                if (_receiveWidgetController.isCompleted) {
                                  await _receiveWidgetController.reverse();

                                  _receiveWidgetController.reset();
                                }
                              },
                              onShareAddress: () {
                                ShareNetWork.shareWalletAddress(
                                  account.address,
                                );
                              },
                            );
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
              }
            },
          ),
        );
      },
    );
  }

  void _showRequestCameraPermission(AppTheme appTheme) async{

    PermissionStatus status = await SystemPermissionHelper.getCurrentCameraPermissionStatus();

    if(status.isGranted){
      final result = await AppNavigator.push(
        RoutePath.scanner,
      );
    }else{
      if(context.mounted){
        DialogProvider.showPermissionDialog(
          context,
          appTheme: appTheme,
          onAccept: () {
            AppNavigator.pop();
            SystemPermissionHelper.requestCameraPermission(
              onSuccessFul: () async {
                final result = await AppNavigator.push(
                  RoutePath.scanner,
                );
              },
              reject: () {
                SystemPermissionHelper.goToSettings();
              },
            );
          },
          headerIconPath: AssetIconPath.commonPermissionCamera,
          titleKey: LanguageKey.commonPermissionCameraTitle,
          contentKey: LanguageKey.commonPermissionCameraContent,
        );
      }
    }
  }
}
