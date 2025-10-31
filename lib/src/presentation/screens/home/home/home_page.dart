import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aurapay/app_configs/di.dart';
import 'package:aurapay/app_configs/aura_pay_config.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/observer/home_page_observer.dart';
import 'package:aurapay/src/core/utils/aura_util.dart';
import 'package:aurapay/src/core/utils/context_extension.dart';
import 'package:aurapay/src/navigator.dart';
import 'package:aurapay/src/presentation/widgets/app_bar_widget.dart';
import 'package:aurapay/src/presentation/widgets/base_screen.dart';

import 'home_page_bloc.dart';
import 'home_page_event.dart';
import 'home_page_selector.dart';
import 'widgets/action.dart';
import 'widgets/app_bar.dart';
import 'widgets/nft.dart';
import 'widgets/story.dart';
import 'widgets/tab.dart';
import 'widgets/token.dart';
import 'widgets/wallet.dart';

/// Home page displaying wallet overview, tokens, NFTs, and portfolio value.
///
/// Features:
/// - Animated wallet card that scales and fades on scroll
/// - Token and NFT tabs
/// - Quick actions (Send, Receive, Swap, etc.)
/// - Story/promotional cards
/// - Real-time balance and market data
class HomePage extends StatefulWidget {
  final void Function(
    Account,
    List<AppNetwork>,
    AppTheme,
    AppLocalizationManager,
  ) onReceivedTap;

  const HomePage({
    required this.onReceivedTap,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with StateFulBaseScreen, SingleTickerProviderStateMixin {
  // Dependencies
  final List<AppNetwork> _networks = getIt.get<List<AppNetwork>>();
  final HomePageObserver _homePageObserver = getIt.get<HomePageObserver>();
  final AuraPayConfig _config = getIt.get<AuraPayConfig>();
  late HomePageBloc _bloc;

  final String avatarAsset = randomAvatar();

  // Controllers
  late TabController _controller;
  late PageController _pageController;
  late ScrollController _scrollController;

  // Animation properties
  final Duration _animatedDuration = const Duration(milliseconds: 300);
  
  final GlobalKey _walletActionKey = GlobalKey();
  double _walletActionOffset = 0;

  final GlobalKey _walletCardKey = GlobalKey();
  double _walletCardOffset = 0;

  double _scrollPosition = 0;
  double _walletCardScale = 1.0;
  double _walletCardOpacity = 1.0;

  double paddingTop = 0;

  bool _showWalletCard = false;
  bool _showActions = false;

  /// Creates and configures the scroll controller with listener.
  void _createScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  /// Disposes the scroll controller and removes listeners.
  void _disposeController() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  /// Handles scroll events to trigger card animations.
  void _scrollListener() {
    _scrollPosition = _scrollController.offset;

    setState(() {
      _detectScrollOverWalletCard();
      _detectScrollOverAction();
    });
  }

  /// Detects if user has scrolled past the action buttons.
  ///
  /// Shows actions in app bar when scrolled past their position.
  void _detectScrollOverAction() {
    // Calculate action offset on first scroll
    if (_walletActionOffset == 0) {
      final renderBox =
          _walletActionKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        _walletActionOffset =
            position.dy + 0.5 * renderBox.size.height - kToolbarHeight;
      }
    }

    // Toggle action visibility based on scroll position
    _showActions =
        _scrollPosition + kToolbarHeight + paddingTop >= _walletActionOffset;
  }

  /// Detects scroll position relative to wallet card for animations.
  ///
  /// Scales and fades the wallet card as user scrolls, and shows
  /// a compact version in the app bar when scrolled past.
  void _detectScrollOverWalletCard() {
    // Calculate wallet card offset on first scroll
    if (_walletCardOffset == 0) {
      final renderBox =
          _walletCardKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        _walletCardOffset =
            position.dy + 0.85 * renderBox.size.height - kToolbarHeight;
      }
    }

    // Calculate scale and opacity based on scroll position
    if (_scrollPosition < _walletCardOffset) {
      _walletCardScale = 1 - (_scrollPosition / _walletCardOffset);
      _walletCardOpacity = 1 - (_scrollPosition / _walletCardOffset);
    }

    // Clamp values to valid range
    _walletCardScale = _walletCardScale.clamp(0.0, 1.0);
    _walletCardOpacity = _walletCardOpacity.clamp(0.0, 1.0);

    // Toggle wallet card visibility in app bar
    _showWalletCard =
        _scrollPosition + kToolbarHeight + paddingTop >= _walletCardOffset;
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize BLoC with configuration
    _bloc = getIt.get<HomePageBloc>(param1: _config);
    
    // Setup tab controller for Token/NFT tabs
    _controller = TabController(length: 2, vsync: this);
    
    // Setup page controller
    _pageController = PageController();
    
    // Setup scroll controller with listener
    _createScrollController();

    // Listen to home page events (e.g., send token completed)
    _homePageObserver.addListener(_homePageListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    _disposeController();
    _homePageObserver.removeListener(_homePageListener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    paddingTop = context.statusBar;
  }

  /// Handles home page events from observer.
  void _homePageListener(HomePageEmitParam param) {
    final event = param.event;
    // final data = param.data; // Reserved for future use

    switch (event) {
      case HomePageObserver.onSendTokenDone:
        // TODO: Refresh balance after token send
        break;
      default:
        break;
    }
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: context.bodyHeight, maxHeight: context.bodyHeight * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: _walletCardOpacity,
              duration: _animatedDuration,
              key: _walletCardKey,
              child: Transform.scale(
                scale: _walletCardScale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HomePageStoryWidget(
                            thumbnail:
                                'https://cdn.pixabay.com/photo/2022/11/30/20/48/turtle-7627773_1280.jpg',
                            title: 'Create passcode',
                            appTheme: appTheme,
                          ),
                          const SizedBox(
                            width: BoxSize.boxSize05,
                          ),
                          HomePageStoryWidget(
                            thumbnail:
                                'https://cdn.pixabay.com/photo/2022/11/30/20/48/turtle-7627773_1280.jpg',
                            title: 'Punka event',
                            appTheme: appTheme,
                          ),
                          const SizedBox(
                            width: BoxSize.boxSize05,
                          ),
                          HomePageStoryWidget(
                            thumbnail:
                                'https://cdn.pixabay.com/photo/2022/11/30/20/48/turtle-7627773_1280.jpg',
                            title: 'Create passcode',
                            appTheme: appTheme,
                          ),
                          const SizedBox(
                            width: BoxSize.boxSize05,
                          ),
                          HomePageStoryWidget(
                            thumbnail:
                                'https://cdn.pixabay.com/photo/2022/11/30/20/48/turtle-7627773_1280.jpg',
                            title: 'Punka event',
                            appTheme: appTheme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize07,
                    ),
                    HomePageWalletCardWidget(
                      appTheme: appTheme,
                      localization: localization,
                      onEnableTokenTap: _onEnableTokenTap,
                      avatarAsset: avatarAsset,
                    )
                  ],
                ),
              ),
            ),
            Column(
              key: _walletActionKey,
              children: [
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                HomePageActiveAccountSelector(
                  builder: (account) {
                    return HomePageActionsWidget(
                      appTheme: appTheme,
                      localization: localization,
                      onSendTap: _onSendTap,
                      onReceiveTap: () {
                        _onReceiveTap(
                          account!,
                          _networks,
                          appTheme,
                          localization,
                        );
                      },
                      onStakingTap: _onStakingTap,
                      onSwapTap: _onSwapTap,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: BoxSize.boxSize05,
            ),
            HomePageTabWidget(
              appTheme: appTheme,
              localization: localization,
              controller: _controller,
              onSelected: _onChangeTab,
            ),
            const SizedBox(
              height: BoxSize.boxSize05,
            ),
            Expanded(
              child: PageView(
                scrollDirection: Axis.horizontal,
                onPageChanged: _onChangePage,
                controller: _pageController,
                children: [
                  HomePageTokensWidget(
                    appTheme: appTheme,
                    localization: localization,
                    config: _config,
                  ),
                  HomePageNFTsWidget(
                    appTheme: appTheme,
                    localization: localization,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: appTheme.bgPrimary,
        appBar: AppBarDefault(
          appTheme: appTheme,
          localization: localization,
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          title: HomePageActiveAccountSelector(
            builder: (account) {
              return HomeAppBar(
                appTheme: appTheme,
                localization: localization,
                onActionClick: _onActionClick,
                showActions: _showActions,
                showWallet: _showWalletCard,
                avatarAsset: avatarAsset,
                onSendTap: _onSendTap,
                onReceiveTap: () {
                  _onReceiveTap(
                    account!,
                    _networks,
                    appTheme,
                    localization,
                  );
                },
                onStakingTap: _onStakingTap,
                onSwapTap: _onSwapTap,
              );
            },
          ),
        ),
        body: child,
      ),
    );
  }

  void _onActionClick() {
    _scrollController.animateTo(
      0,
      duration: _animatedDuration,
      curve: Curves.easeOut,
    );
  }

  void _onChangePage(int page) {
    _controller.animateTo(
      page,
      duration: _animatedDuration,
      curve: Curves.ease,
    );
  }

  void _onChangeTab(int page) {
    _pageController.animateToPage(
      page,
      duration: _animatedDuration,
      curve: Curves.ease,
    );
  }

  void _onEnableTokenTap() {
    _bloc.add(
      const HomePageOnUpdateEnableTotalTokenEvent(),
    );
  }

  void _onSendTap() {
    AppNavigator.push(RoutePath.send);
  }

  void _onReceiveTap(
    Account account,
    List<AppNetwork> networks,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    widget.onReceivedTap(
      account,
      networks,
      appTheme,
      localization,
    );
  }

  void _onSwapTap() {

  }

  void _onStakingTap() {}
}
