import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/aura_ecosystem.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/browser/widgets/browser_suggestion_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/browser/widgets/tab_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'widgets/search_widget.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
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
                    onViewTap: () {},
                    onSearchTap: () {
                      AppNavigator.push(
                        RoutePath.browserSearch,
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
                        TabWidget(
                          appTheme: appTheme,
                          onSelect: (index) {},
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize07,
                        ),
                        Expanded(
                          child: CombinedListView(
                            onRefresh: () {
                              //
                            },
                            onLoadMore: () {
                              //
                            },
                            data: auraEcosystems,
                            builder: (browser, _) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Spacing.spacing06,
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    AppNavigator.push(
                                      RoutePath.browser,
                                      browser.url,
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: BrowserSuggestionWidget(
                                    name: browser.name,
                                    description: browser.description ?? '',
                                    logo: browser.logo,
                                    appTheme: appTheme,
                                    suffix: const SizedBox(),
                                  ),
                                ),
                              );
                            },
                            canLoadMore: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
