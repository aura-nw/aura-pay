import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'browser_page_event.dart';
import 'browser_page_selector.dart';
import 'widgets/book_mark_more_action_widget.dart';
import 'browser_page_bloc.dart';
import 'widgets/browser_suggestion_widget.dart';
import 'widgets/tab_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'widgets/search_widget.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final BrowserPageBloc _bloc = getIt.get();

  final HomeScreenObserver _homeScreenObserver =
      getIt.get<HomeScreenObserver>();

  void _registerEvent(HomeScreenEmitParam param) {
    if (param.event == HomeScreenObserver.onInAppBrowserRefreshEvent) {
      _bloc.add(
        const BrowserPageOnInitEvent(),
      );
    }
  }

  @override
  void initState() {
    _homeScreenObserver.addListener(_registerEvent);
    super.initState();
  }

  @override
  void dispose() {
    _homeScreenObserver.removeListener(_registerEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: Scaffold(
            backgroundColor: appTheme.bodyColorBackground,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing07,
                      vertical: Spacing.spacing06,
                    ),
                    child: SearchWidget(
                      appTheme: appTheme,
                      onViewTap: () async {
                        await AppNavigator.push(
                          RoutePath.browserTabManagement,
                        );

                        _bloc.add(
                          const BrowserPageOnInitEvent(),
                        );
                      },
                      onSearchTap: () async {
                        await AppNavigator.push(
                          RoutePath.browserSearch,
                        );

                        _bloc.add(
                          const BrowserPageOnInitEvent(),
                        );
                      },
                    ),
                  ),
                  const HoLiZonTalDividerWidget(),
                  const SizedBox(
                    height: BoxSize.boxSize06,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.spacing07,
                        vertical: Spacing.spacing02,
                      ),
                      child: Column(
                        children: [
                          BrowserPageTabSelector(
                            builder: (selectedTab) {
                              return TabWidget(
                                appTheme: appTheme,
                                selectedTab: selectedTab,
                                onSelect: (index) {
                                  _bloc.add(
                                    BrowserPageOnChangeTabEvent(
                                      index: index,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize07,
                          ),
                          Expanded(
                            child: BrowserPageTabSelector(
                              builder: (selectedTab) {
                                return AnimatedCrossFade(
                                  duration: const Duration(
                                    milliseconds: 700,
                                  ),
                                  crossFadeState: selectedTab == 0
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: BrowserPageEcosystemsSelector(
                                    builder: (ecosystems) {
                                      return SizedBox(
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        child: CombinedListView(
                                          onRefresh: () {
                                            //
                                          },
                                          onLoadMore: () {
                                            //
                                          },
                                          data: ecosystems,
                                          builder: (browser, _) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: Spacing.spacing06,
                                              ),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await AppNavigator.push(
                                                    RoutePath.browser,
                                                    browser.url,
                                                  );

                                                  _bloc.add(
                                                    const BrowserPageOnInitEvent(),
                                                  );
                                                },
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                child: BrowserSuggestionWidget(
                                                  name: browser.name,
                                                  description:
                                                      browser.description ?? '',
                                                  logo: browser.logo,
                                                  appTheme: appTheme,
                                                  suffix: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal:
                                                          Spacing.spacing05,
                                                      vertical:
                                                          Spacing.spacing02,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        BorderRadiusSize
                                                            .borderRadiusRound,
                                                      ),
                                                      border: Border.all(
                                                        color: appTheme
                                                            .borderColorGrayDefault,
                                                      ),
                                                    ),
                                                    child:
                                                        AppLocalizationProvider(
                                                      builder:
                                                          (localization, _) {
                                                        return Text(
                                                          localization
                                                              .translate(
                                                            LanguageKey
                                                                .inAppBrowserPageOpen,
                                                          ),
                                                          style: AppTypoGraPhy
                                                              .bodyMedium02
                                                              .copyWith(
                                                            color: appTheme
                                                                .contentColor700,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          canLoadMore: false,
                                        ),
                                      );
                                    },
                                  ),
                                  secondChild: BrowserPageBookMarksSelector(
                                    builder: (bookMark) {
                                      if (bookMark.isEmpty) {
                                        return Center(
                                          child: AppLocalizationProvider(
                                            builder: (localization, _) {
                                              return Text(
                                                localization.translate(
                                                  LanguageKey
                                                      .inAppBrowserNoBookMarkFound,
                                                ),
                                                style: AppTypoGraPhy
                                                    .bodyMedium02
                                                    .copyWith(
                                                  color:
                                                      appTheme.contentColor500,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      return SizedBox(
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        child: CombinedListView(
                                          onRefresh: () {
                                            //
                                          },
                                          onLoadMore: () {
                                            //
                                          },
                                          data: bookMark,
                                          builder: (bookMark, _) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: Spacing.spacing06,
                                              ),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await AppNavigator.push(
                                                    RoutePath.browser,
                                                    bookMark.url,
                                                  );

                                                  _bloc.add(
                                                    const BrowserPageOnInitEvent(),
                                                  );
                                                },
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                child: BrowserSuggestionWidget(
                                                  name: bookMark.name,
                                                  description: bookMark.url,
                                                  logo: bookMark.logo,
                                                  appTheme: appTheme,
                                                  suffix:
                                                      BookMarkMoreActionWidget(
                                                    appTheme: appTheme,
                                                    onDelete: () {
                                                      _bloc.add(
                                                        BrowserPageOnDeleteBookMarkEvent(
                                                          id: bookMark.id,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          canLoadMore: false,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
