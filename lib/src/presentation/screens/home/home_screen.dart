import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/helpers/share_network.dart';
import 'package:pyxis_mobile/src/core/helpers/system_permission_helper.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_state.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/widgets/tab_builder.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'home/widgets/receive_token_widget.dart';
import 'home_screen_bloc.dart';
import 'widgets/bottom_navigator_bar_widget.dart';

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

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, CustomFlutterToast {
  late HomeScreenSection currentSection;

  late AnimationController _receiveWidgetController;
  late Animation _receiveAnimation;

  final HomeScreenBloc _bloc = getIt.get<HomeScreenBloc>();

  @override
  void initState() {
    // Initialize the state
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
    // Set up the animation
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

  void _onReceiveTap() {
    // Start the receive widget animation
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
                  // Show loading indicator
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
                        body: HomeScreenTabBuilder(
                          currentSection: currentSection,
                          onReceiveTap: _onReceiveTap,
                        ),
                        bottomNavigationBar: BottomNavigatorBarWidget(
                          currentIndex: HomeScreenSection.values.indexOf(
                            currentSection,
                          ),
                          appTheme: appTheme,
                          onScanTap: () {
                            // Show camera permission dialog
                            _showRequestCameraPermission(
                              appTheme,
                            );
                          },
                          onTabSelect: (index) {
                            // Change the current section
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
                                  // Reverse the receive widget animation
                                  await _receiveWidgetController.reverse();

                                  _receiveWidgetController.reset();
                                }
                              },
                              onShareAddress: () {
                                // Share wallet address
                                ShareNetWork.shareWalletAddress(
                                  account.address,
                                );
                              },
                              onCopyAddress: _onCopyAddress,
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

  void _showRequestCameraPermission(AppTheme appTheme) async {
    // Check camera permission status
    PermissionStatus status =
        await SystemPermissionHelper.getCurrentCameraPermissionStatus();

    if (status.isGranted) {
      // Camera permission is granted, navigate to scanner screen
      final result = await AppNavigator.push(
        RoutePath.scanner,
      );
      LogProvider.log(
          'scanner isGranted = ${status.isGranted} | result = $result');
    } else {
      if (context.mounted) {
        // Show camera permission dialog
        DialogProvider.showPermissionDialog(
          context,
          appTheme: appTheme,
          onAccept: () {
            AppNavigator.pop();
            SystemPermissionHelper.requestCameraPermission(
              onSuccessFul: () async {
                // Camera permission is granted, navigate to scanner screen
                final result = await AppNavigator.push(
                  RoutePath.scanner,
                );
                LogProvider.log('scanner result $result');
              },
              reject: () {
                // Open app settings
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

  void _onCopyAddress(String address) async {
    // Copy the address to clipboard
    await Clipboard.setData(
      ClipboardData(text: address),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
        // Show toast message
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.globalPyxisCopyMessage,
            {
              'value': 'address',
            },
          ),
        );
      }
    }
  }
}
