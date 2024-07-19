import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/context_extension.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home/widgets/nft.dart';
import 'home_page_selector.dart';
import 'home_page_event.dart';
import 'widgets/action.dart';
import 'widgets/story.dart';
import 'widgets/tab.dart';
import 'widgets/token.dart';
import 'widgets/wallet.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';
import 'package:pyxis_v2/src/presentation/widgets/circle_avatar_widget.dart';

import 'home_page_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with StateFulBaseScreen, SingleTickerProviderStateMixin {
  late HomePageBloc _bloc;

  final GlobalKey _walletActionKey = GlobalKey();
  double _walletActionOffset = 0;

  final GlobalKey _walletCardKey = GlobalKey();
  double _walletCardOffset = 0;

  final PyxisMobileConfig _config = getIt.get<PyxisMobileConfig>();
  late TabController _controller;
  late PageController _pageController;

  late ScrollController _scrollController;

  final Duration _animatedDuration = const Duration(
    milliseconds: 300,
  );
  double _scrollPosition = 0;
  double _walletCardScale = 1.0;
  double _walletCardOpacity = 1.0;

  double paddingTop = 0;

  bool _showWalletCard = false;
  bool _showActions = false;

  void _createScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _disposeController() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    _scrollPosition = _scrollController.offset;

    setState(
      () {
        _detectScrollOverWalletCard();
        _detectScrollOverAction();
      },
    );
  }

  void _detectScrollOverAction() {
    if (_walletActionOffset == 0) {
      final RenderBox? renderBox =
          _walletActionKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        Offset position = renderBox.localToGlobal(Offset.zero);
        _walletActionOffset =
            position.dy + renderBox.size.height - kToolbarHeight;
      }
    }

    if (_scrollPosition + kToolbarHeight + paddingTop >= _walletActionOffset) {
      _showActions = true;
    } else {
      _showActions = false;
    }
  }

  void _detectScrollOverWalletCard() {
    if (_walletCardOffset == 0) {
      final RenderBox? renderBox =
          _walletCardKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        Offset position = renderBox.localToGlobal(Offset.zero);
        _walletCardOffset =
            position.dy + renderBox.size.height - kToolbarHeight;
      }
    }

    if (_scrollPosition < _walletCardOffset) {
      _walletCardScale = 1 - (_scrollPosition / _walletCardOffset);

      _walletCardOpacity = 1 - (_scrollPosition / _walletCardOffset);
    }

    _walletCardScale = _walletCardScale.clamp(0.0, 1.0);

    _walletCardOpacity = _walletCardOpacity.clamp(0.0, 1.0);

    if (_scrollPosition + kToolbarHeight + paddingTop >= _walletCardOffset) {
      _showWalletCard = true;
    } else {
      _showWalletCard = false;
    }
  }

  @override
  void initState() {
    _bloc = getIt.get<HomePageBloc>(
      param1: _config,
    );
    _controller = TabController(length: 2, vsync: this);

    _pageController = PageController();
    _createScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _disposeController();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    paddingTop = context.statusBar;
    super.didChangeDependencies();
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
                  children: [
                    Row(
                      children: [
                        HomePageStoryWidget(
                          thumbnail:
                              'https://s3-alpha-sig.figma.com/img/92cd/b81b/8238a519c91c475eb512ebb07d5e6bdb?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=T7rGW5KpFMTYl0m8ml8YvK2wYvBxqwZGmDuzEgdA-B0vwvvAF-mK8oHNEzSCvBj8UvL2ky4Knh9tR~yTWA3TLBKf~AhK8LehQ8sIsWUQak5dSlLQTV7NM-bnvpXmxX0CAwpIxQ3M8k8yZFsTf1k9SmQ8iUbypy~LbyfRmue0l4Rre8cUCd5cLQx07fK9siQJsEojYKnvZn57OIApGnDaMiq7UDr-RgW-labJ39r6GMUolonURyO8cfpsxxw~xuoM0NLnsyp~r5o0uUBwmzd9V5NbSJRhm6IJXTTHjIHQwaSUB1aBygzYnWauecHSbDkGyUfUTyuc-ESdBKf0vMcd9Q__',
                          title: 'Create passcode',
                          appTheme: appTheme,
                        ),
                        const SizedBox(
                          width: BoxSize.boxSize05,
                        ),
                        HomePageStoryWidget(
                          thumbnail:
                              'https://s3-alpha-sig.figma.com/img/c181/d11c/d352d2d1efbc59d8499e1b3c16352240?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=O2ApS0-GuiWDOsjHmUpVUFHoWPIJ3Is74oK9H1ME4ztzcvrtCvdrFs-hgtM3YEB7hA9vIsoJff3FRmj9SQz03BWjzIfr~RoH8kQo7R6Vdt0Kp8oeaIliiz1jJBJnonnhIaPY4VvAxbOzO8y2uB9KW3iryivqP4nsecwovOuxCUXkGS-UfQMCfSLlxhTk82gD~hFPCbpVYppF1igAmJGQWaIDx9vziGB4IrRy2scOk1wtd4clr~77hE1g5Ts80QbD95m4591peGMRSjlGdUgC5aDlxvykXXKWcQS0VPWG7uE9HwPtTBm6IcTum9HPG~k429rVHZbDT25~8isRrPpGBQ__',
                          title: 'Punka event',
                          appTheme: appTheme,
                        ),
                        const SizedBox(
                          width: BoxSize.boxSize05,
                        ),
                        HomePageStoryWidget(
                          thumbnail:
                              'https://s3-alpha-sig.figma.com/img/92cd/b81b/8238a519c91c475eb512ebb07d5e6bdb?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=T7rGW5KpFMTYl0m8ml8YvK2wYvBxqwZGmDuzEgdA-B0vwvvAF-mK8oHNEzSCvBj8UvL2ky4Knh9tR~yTWA3TLBKf~AhK8LehQ8sIsWUQak5dSlLQTV7NM-bnvpXmxX0CAwpIxQ3M8k8yZFsTf1k9SmQ8iUbypy~LbyfRmue0l4Rre8cUCd5cLQx07fK9siQJsEojYKnvZn57OIApGnDaMiq7UDr-RgW-labJ39r6GMUolonURyO8cfpsxxw~xuoM0NLnsyp~r5o0uUBwmzd9V5NbSJRhm6IJXTTHjIHQwaSUB1aBygzYnWauecHSbDkGyUfUTyuc-ESdBKf0vMcd9Q__',
                          title: 'Create passcode',
                          appTheme: appTheme,
                        ),
                        const SizedBox(
                          width: BoxSize.boxSize05,
                        ),
                        HomePageStoryWidget(
                          thumbnail:
                              'https://s3-alpha-sig.figma.com/img/92cd/b81b/8238a519c91c475eb512ebb07d5e6bdb?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=T7rGW5KpFMTYl0m8ml8YvK2wYvBxqwZGmDuzEgdA-B0vwvvAF-mK8oHNEzSCvBj8UvL2ky4Knh9tR~yTWA3TLBKf~AhK8LehQ8sIsWUQak5dSlLQTV7NM-bnvpXmxX0CAwpIxQ3M8k8yZFsTf1k9SmQ8iUbypy~LbyfRmue0l4Rre8cUCd5cLQx07fK9siQJsEojYKnvZn57OIApGnDaMiq7UDr-RgW-labJ39r6GMUolonURyO8cfpsxxw~xuoM0NLnsyp~r5o0uUBwmzd9V5NbSJRhm6IJXTTHjIHQwaSUB1aBygzYnWauecHSbDkGyUfUTyuc-ESdBKf0vMcd9Q__',
                          title: 'Punka event',
                          appTheme: appTheme,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize07,
                    ),
                    HomePageWalletCardWidget(
                      appTheme: appTheme,
                      localization: localization,
                      onEnableTokenTap: _onEnableTokenTap,
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
                HomePageActionsWidget(
                  appTheme: appTheme,
                  localization: localization,
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetIconPath.icCommonAura,
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              Text(
                _config.config.appName,
                style: AppTypoGraPhy.textSmSemiBold.copyWith(
                  color: appTheme.textPrimary,
                ),
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              SvgPicture.asset(
                AssetIconPath.icCommonArrowDown,
              ),
            ],
          ),
          actions: _actions(),
        ),
        body: child,
      ),
    );
  }

  List<Widget> _actions() {
    List<Widget> actions = List.empty(growable: true);

    if (_showWalletCard) {
      actions.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _scrollController.animateTo(
            0,
            duration: _animatedDuration,
            curve: Curves.easeOut,
          );
        },
        child: const Row(
          children: [
            CircleAvatarWidget(
              image: AssetImage(
                AssetImagePath.defaultAvatar1,
              ),
              radius: BorderRadiusSize.borderRadius04,
            ),
            SizedBox(
              width: BoxSize.boxSize04,
            ),
          ],
        ),
      ));
    }

    if (_showActions) {
      actions.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _scrollController.animateTo(
              0,
              duration: _animatedDuration,
              curve: Curves.easeOut,
            );
          },
          child: const Row(
            children: [
              CircleAvatarWidget(
                image: AssetImage(
                  AssetImagePath.defaultAvatar1,
                ),
                radius: BorderRadiusSize.borderRadius04,
              ),
              SizedBox(
                width: BoxSize.boxSize04,
              ),
            ],
          ),
        ),
      );
    }

    return actions;
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
}
