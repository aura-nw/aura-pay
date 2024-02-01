import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_cubit.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/helpers/share_network.dart';
import 'package:pyxis_mobile/src/core/helpers/system_permission_helper.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_state.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/widgets/tab_builder.dart';
import 'package:pyxis_mobile/src/presentation/screens/wallet_connect_screen/wallet_connect_screen.dart';
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

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  void _onEmitAccountChange() {
    _observer.emit(
      emitParam: HomeScreenEmitParam(
        event: HomeScreenObserver.onListenAccountChangeEvent,
        data: true,
      ),
    );
  }

  void _listenHomeObserver(HomeScreenEmitParam param) {
    if (param.event == HomeScreenObserver.onHomePageDropdownClickEvent) {
      if (param.data == true && currentSection.index != 1) {
        // Change to account page. Index = 1. Maybe change index late.
        setState(() {
          currentSection = HomeScreenSection.accounts;
        });
      }
    }
  }

  @override
  void initState() {
    _observer.addListener(_listenHomeObserver);
    _bloc.registerCallBack(_onEmitAccountChange);
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

  void _onReceiveTap() {
    _receiveWidgetController.forward();
  }

  @override
  void dispose() {
    _observer.removeListener(_listenHomeObserver);
    _bloc.registerCallBack(_onEmitAccountChange);
    super.dispose();
  }

  // Override the build method for the widget
  @override
  Widget build(BuildContext context) {
    // Use the AppThemeBuilder to dynamically set the app theme
    return AppThemeBuilder(
      builder: (appTheme) {
        // Provide the SendTransactionBloc using BlocProvider
        return PopScope(
          canPop: false,
          child: BlocProvider.value(
            value: _bloc,
            // Use HomeScreenStatusSelector to handle different screen statuses
            child: HomeScreenStatusSelector(
              builder: (status) {
                // Switch statement to handle different screen statuses
                switch (status) {
                  case HomeScreenStatus.loading:
                    // Display a loading widget when the screen is in loading state
                    return Center(
                      child: AppLoadingWidget(
                        appTheme: appTheme,
                      ),
                    );
                  case HomeScreenStatus.loaded:
                  case HomeScreenStatus.error:
                    // Stack widget to overlay multiple UI components
                    return Stack(
                      children: [
                        // Main scaffold containing the home screen and bottom navigation bar
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
                              // Show camera permission request when the scan button is tapped
                              _showRequestCameraPermission(
                                appTheme,
                              );
                            },
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
                            },
                          ),
                        ),
                        // AnimatedBuilder for receiving widget animation
                        AnimatedBuilder(
                          animation: _receiveWidgetController,
                          child: HomeScreenAccountsSelector(
                            builder: (accounts) {
                              // Retrieve the first account (if available)
                              final account = accounts.firstOrNull;
                              // Display the ReceiveTokenWidget with account details
                              return ReceiveTokenWidget(
                                accountName: account?.name ?? '',
                                address: account?.address ?? '',
                                theme: appTheme,
                                onSwipeUp: () async {
                                  // Reverse the animation when the widget is swiped up
                                  if (_receiveWidgetController.isCompleted) {
                                    await _receiveWidgetController.reverse();
                                    _receiveWidgetController.reset();
                                  }
                                },
                                onShareAddress: () {
                                  // Share the wallet address
                                  ShareNetWork.shareWalletAddress(
                                    account?.address ?? '',
                                  );
                                },
                                onCopyAddress: _onCopyAddress,
                              );
                            },
                          ),
                          // Apply translation to the child based on the animation value
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
          ),
        );
      },
    );
  }

  void _showRequestCameraPermission(AppTheme appTheme) async {
    String? account = _bloc.state.selectedAccount?.address;
    WalletConnectCubit.of(context).registerSmartAccount(account ?? '');

    PermissionStatus status =
        await SystemPermissionHelper.getCurrentCameraPermissionStatus();

    String? result;

    if (status.isGranted) {
      result = await AppNavigator.push(
        RoutePath.scanner,
      );
    } else {
      if (context.mounted) {
        DialogProvider.showPermissionDialog(
          context,
          appTheme: appTheme,
          onAccept: () {
            AppNavigator.pop();
            SystemPermissionHelper.requestCameraPermission(
              onSuccessFul: () async {
                result = await AppNavigator.push(
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

    if (result != null) {
      String? account = _bloc.state.selectedAccount?.address;
      WalletConnectCubit.of(context).connect(result ?? '', account ?? '');

      // if (result != null) {
      //   WalletConnectScreenData connectScreenData =
      //       WalletConnectScreenData(url: result!, selectedAccount: account ?? '');
      //   await AppNavigator.push(
      //     RoutePath.walletConnect,
      //     connectScreenData,
      //   );
    }
  }

  void _onCopyAddress(String address) async {
    await Clipboard.setData(
      ClipboardData(text: address),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
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
