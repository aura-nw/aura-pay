import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aurapay/app_configs/di.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme_builder.dart';
import 'package:aurapay/src/application/global/localization/app_localization_provider.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/helpers/share_network.dart';
import 'package:aurapay/src/core/utils/context_extension.dart';
import 'package:aurapay/src/core/utils/copy.dart';
import 'package:aurapay/src/core/utils/toast.dart';
import 'package:aurapay/src/navigator.dart';
import 'package:aurapay/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_provider.dart';
import 'package:aurapay/src/presentation/widgets/select_network_widget.dart';

import 'home_bloc.dart';
import 'home_event.dart';
import 'home_selector.dart';
import 'widgets/bottom_navigator_bar_widget.dart';
import 'widgets/receive_token.dart';
import 'widgets/tab_builder.dart';

/// Main sections of the home screen.
enum HomeScreenSection {
  wallet,
  browser,
  home,
  history,
  setting,
}

/// Home screen - the main hub of the application.
///
/// Features:
/// - Bottom navigation with 5 tabs (Wallet, Browser, Home, History, Settings)
/// - Receive token overlay with QR code
/// - Network selection for multi-chain support
/// - Account management and address sharing
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, CustomFlutterToast, Copy {
  late HomeScreenSection currentSection;
  late AnimationController _receiveWidgetController;
  late Animation<double> _receiveAnimation;

  final HomeBloc _bloc = getIt.get<HomeBloc>();

  late AppNetwork appNetwork;

  @override
  void initState() {
    super.initState();
    
    // Initialize default network (first network from the list)
    appNetwork = getIt.get<List<AppNetwork>>()[0];
    
    // Set default tab to home
    currentSection = HomeScreenSection.home;
    
    // Setup animation controller for receive token overlay
    _receiveWidgetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    // Initialize home screen data
    _bloc.add(const HomeOnInitEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Setup slide-up animation for receive token widget
    _receiveAnimation = Tween<double>(
      begin: -context.h, // Start from above screen
      end: 0, // End at top of screen
    ).animate(
      CurvedAnimation(
        parent: _receiveWidgetController,
        curve: Curves.easeOutSine,
      ),
    );
  }

  /// Handles receive token button tap.
  ///
  /// If multiple networks are available, shows network selection bottom sheet.
  /// Otherwise, directly shows the QR code for the default network.
  void _onReceiveTap(
    Account account,
    List<AppNetwork> networks,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    // Show network selection if multiple networks are available
    if (networks.length == 2) {
      AppBottomSheetProvider.showFullScreenDialog(
        context,
        child: SelectNetworkAccountReceiveWidget(
          appTheme: appTheme,
          localization: localization,
          networks: networks,
          account: account,
          onShowQr: (account, network) {
            // Close bottom sheet and show QR code for selected network
            AppNavigator.pop();
            appNetwork = network;
            setState(() {});
            _receiveWidgetController.forward();
          },
          onCopy: (address) {
            // Close bottom sheet and copy address
            AppNavigator.pop();
            _onCopy(address);
          },
        ),
        appTheme: appTheme,
      );
    }
    // TODO: Handle single network case
  }

  /// Copies the address to clipboard and shows toast.
  void _onCopy(String address) {
    copy(address);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back navigation from home screen
      child: BlocProvider.value(
        value: _bloc,
        child: AppThemeBuilder(
          builder: (appTheme) {
            return AppLocalizationProvider(
              builder: (localization) {
                return Stack(
                  children: [
                    // Main scaffold with tabs and bottom navigation
                    Scaffold(
                      body: SafeArea(
                        child: HomeScreenTabBuilder(
                          currentSection: currentSection,
                          onReceivedTap: _onReceiveTap,
                        ),
                      ),
                      bottomNavigationBar: BottomNavigatorBarWidget(
                        currentIndex: HomeScreenSection.values.indexOf(currentSection),
                        appTheme: appTheme,
                        onTabSelect: (index) {
                          final newSection = HomeScreenSection.values[index];

                          // Ignore if same tab is selected
                          if (currentSection == newSection) return;

                          // Update current section
                          setState(() {
                            currentSection = newSection;
                          });
                        },
                        localization: localization,
                      ),
                    ),
                    
                    // Receive token overlay with slide-up animation
                    AnimatedBuilder(
                      animation: _receiveWidgetController,
                      child: HomeActiveAccountSelector(
                        builder: (account) {
                          return ReceiveTokenWidget(
                            network: appNetwork,
                            account: account,
                            theme: appTheme,
                            localization: localization,
                            onSwipeUp: () async {
                              // Dismiss overlay when swiped up
                              if (_receiveWidgetController.isCompleted) {
                                await _receiveWidgetController.reverse();
                                _receiveWidgetController.reset();
                              }
                            },
                            onShareAddress: _onShareAddress,
                            onCopyAddress: _onCopy,
                            onDownload: () {
                              // TODO: Implement QR code download
                            },
                          );
                        },
                      ),
                      builder: (context, child) {
                        // Apply vertical translation based on animation value
                        return Transform.translate(
                          offset: Offset(0, _receiveAnimation.value),
                          child: child ?? const SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Shares the wallet address using system share dialog.
  void _onShareAddress(String address) {
    ShareNetWork.shareText(address);
  }
}

