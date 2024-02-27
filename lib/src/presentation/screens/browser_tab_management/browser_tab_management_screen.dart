import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'widgets/browser_history_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combined_gridview.dart';
import 'widgets/browser_tab_management_bottom_widget.dart';
import 'browser_tab_management_event.dart';
import 'browser_tab_management_state.dart';
import 'browser_tab_management_bloc.dart';
import 'browser_tab_management_selector.dart';

class BrowserTabManagementScreen extends StatefulWidget {
  const BrowserTabManagementScreen({super.key});

  @override
  State<BrowserTabManagementScreen> createState() =>
      _BrowserTabManagementScreenState();
}

class _BrowserTabManagementScreenState
    extends State<BrowserTabManagementScreen> {
  final BrowserTabManagementBloc _bloc = getIt.get<BrowserTabManagementBloc>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child:
              BlocListener<BrowserTabManagementBloc, BrowserTabManagementState>(
            listener: (context, state) {
              switch (state.status) {
                case BrowserTabManagementStatus.loading:
                  break;
                case BrowserTabManagementStatus.loaded:
                  break;
                case BrowserTabManagementStatus.closeTabSuccess:
                  break;
                case BrowserTabManagementStatus.closeAllSuccess:
                  AppNavigator.replaceWith(
                    RoutePath.browser,
                    _bloc.googleSearchUrl,
                  );
                  break;
                case BrowserTabManagementStatus.addTabSuccess:
                  AppNavigator.replaceWith(
                    RoutePath.browser,
                    _bloc.googleSearchUrl,
                  );
                  break;
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: BrowserTabManagementStatusSelector(
                  builder: (status) {
                    switch (status) {
                      case BrowserTabManagementStatus.loading:
                        return Center(
                          child: AppLoadingWidget(
                            appTheme: appTheme,
                          ),
                        );
                      case BrowserTabManagementStatus.loaded:
                      case BrowserTabManagementStatus.closeAllSuccess:
                      case BrowserTabManagementStatus.closeTabSuccess:
                      case BrowserTabManagementStatus.addTabSuccess:
                        return Column(
                          children: [
                            const SizedBox(
                              height: BoxSize.boxSize07,
                            ),
                            Expanded(
                              child: BrowserTabManagementBrowsersSelector(
                                  builder: (browsers) {
                                if (browsers.isEmpty) {
                                  return Center(
                                    child: AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return Text(
                                          localization.translate(
                                            LanguageKey
                                                .browserManagementScreenNoTabFound,
                                          ),
                                          style: AppTypoGraPhy.bodyMedium02
                                              .copyWith(
                                            color: appTheme.contentColor500,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return CombinedGridView(
                                  childCount: 2,
                                  onRefresh: () async {
                                    //
                                  },
                                  onLoadMore: () {
                                    //
                                  },
                                  data: browsers,
                                  builder: (browser, index) {
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        AppNavigator.replaceWith(
                                          RoutePath.browser,
                                          browser.url,
                                        );
                                      },
                                      child: BrowserHistoryWidget(
                                        appTheme: appTheme,
                                        siteName: browser.siteTitle,
                                        imageUri: browser.screenShotUri,
                                        logo: browser.logo,
                                        key: ValueKey(browser),
                                        onClose: () {
                                          _bloc.add(
                                            BrowserTabManagementOnCloseTabEvent(
                                              id: browser.id,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  canLoadMore: false,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: Spacing.spacing06,
                                  mainAxisSpacing: Spacing.spacing07,
                                );
                              }),
                            ),
                            BrowserTabManagementBottomWidget(
                              onAddNewTab: () {
                                _bloc.add(
                                  const BrowserTabManagementOnAddNewTabEvent(),
                                );
                              },
                              onCloseAll: () {
                                _bloc.add(
                                  const BrowserTabManagementOnClearEvent(),
                                );
                              },
                              appTheme: appTheme,
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
