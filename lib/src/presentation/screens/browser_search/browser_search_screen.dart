import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'browser_search_selector.dart';
import 'browser_search_bloc.dart';
import 'browser_search_event.dart';
import 'widgets/browser_suggestion_widget.dart';
import 'widgets/google_suggestion_result_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'widgets/search_widget.dart';

class BrowserSearchScreen extends StatefulWidget {
  const BrowserSearchScreen({super.key});

  @override
  State<BrowserSearchScreen> createState() => _BrowserSearchScreenState();
}

class _BrowserSearchScreenState extends State<BrowserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final BrowserSearchBloc _bloc = getIt.get<BrowserSearchBloc>();

  String getGoogleQuery(String query) {
    return 'https://www.google.com/search?q=$query';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: Scaffold(
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing07,
                      vertical: Spacing.spacing06,
                    ),
                    child: SearchWidget(
                      controller: _searchController,
                      appTheme: appTheme,
                      onClear: _onClearSearch,
                      onChanged: _onChange,
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize05,
                  ),
                  BrowserSearchSystemsSelector(builder: (auraEcosystems) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.spacing07,
                      ),
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        final browser = auraEcosystems[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: Spacing.spacing06,
                          ),
                          child: BrowserEcosystemSuggestionWidget(
                            name: browser.name,
                            description: browser.description ?? '',
                            logo: browser.logo,
                            appTheme: appTheme,
                            onTap: () {
                              AppNavigator.replaceWith(
                                RoutePath.browser,
                                browser.url,
                              );
                            },
                          ),
                        );
                      },
                      itemCount: auraEcosystems.length,
                    );
                  }),
                  BrowserSearchQuerySelector(
                    builder: (query) {
                      if (query.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          const HoLiZonTalDividerWidget(),
                          const SizedBox(
                            height: BoxSize.boxSize06,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.spacing07,
                              vertical: Spacing.spacing02,
                            ),
                            child: AppLocalizationProvider(
                              builder: (localization, _) {
                                return GoogleSuggestionResultWidget(
                                  description: localization.translate(
                                    LanguageKey
                                        .inAppBrowserSearchScreenSearchWithGoogle,
                                  ),
                                  appTheme: appTheme,
                                  name: query,
                                  onTap: () {
                                    AppNavigator.replaceWith(
                                      RoutePath.browser,
                                      getGoogleQuery(query),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onClearSearch() {
    _searchController.clear();
    _bloc.add(
      const BrowserSearchOnQueryEvent(
        query: '',
      ),
    );
  }

  void _onChange(String value){
    _bloc.add(
       BrowserSearchOnQueryEvent(
        query: value,
      ),
    );
  }
}
