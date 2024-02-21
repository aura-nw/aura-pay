import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing07,
                    vertical: Spacing.spacing06,
                  ),
                  child: SearchWidget(
                    controller: _searchController,
                    appTheme: appTheme,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize08,
                ),
                const HoLiZonTalDividerWidget(),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing07,
                    vertical: Spacing.spacing02,
                  ),
                  child: GoogleSuggestionResultWidget(
                    description: 'Search with google',
                    appTheme: appTheme,
                    //name: _searchController.text.trim(),
                    name: 'Abc',
                    onTap: () {
                      AppNavigator.replaceWith(
                        RoutePath.browser,
                        'https://www.google.com/search?q=${_searchController.text.trim()}',
                      );
                    },
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
