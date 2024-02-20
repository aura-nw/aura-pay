import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/debug.dart';
import 'package:pyxis_mobile/src/presentation/screens/connect_site/connect_site_detail/site_detail_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/connect_site/widgets/site_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

// Define a screen for connecting to external sites
class ConnectSiteScreen extends StatefulWidget {
  const ConnectSiteScreen({Key? key}) : super(key: key);

  @override
  State<ConnectSiteScreen> createState() => _ConnectSiteScreenState();
}

class _ConnectSiteScreenState extends State<ConnectSiteScreen> {
  List<SessionData>? listConnectedSites;

  @override
  void initState() {
    super.initState();

    // Initialize the list of connected sites
    listConnectedSites = GetIt.I.get<WalletConnectService>().sessionsList;
    debug.log('listConnectedSites: $listConnectedSites');
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          // Define the app bar with title
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey: LanguageKey.connectSiteScreenAppBarTitle,
          ),
          // Define the body of the screen
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing05,
            ),
            child: Column(
              children: [
                // Display a localized text describing the content
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        LanguageKey.connectSiteScreenContent,
                      ),
                      style: AppTypoGraPhy.body02.copyWith(
                        color: appTheme.contentColor700,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
                Expanded(
                  child: CombinedListView<SessionData>(
                    // Define behavior for refreshing the list
                    onRefresh: () {
                      listConnectedSites =
                          GetIt.I.get<WalletConnectService>().sessionsList;
                      debug.log('listConnectedSites: $listConnectedSites');
                      setState(() {});
                    },
                    // Define behavior for loading more items (if applicable)
                    onLoadMore: () {},
                    // Provide the data to be displayed in the list
                    data: listConnectedSites ?? [],
                    // Define the builder function for creating list items
                    builder: (sessionData, index) {
                      return GestureDetector(
                        // Handle tap on the list item
                        onTap: () async {
                          // Navigate to the site detail screen or perform action
                          // when a site is tapped
                          // Example:
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SiteDetailScreen(sessionData),
                            ),
                          );
                          debug.log('Site tapped: ${sessionData.topic}');

                          listConnectedSites =
                              GetIt.I.get<WalletConnectService>().sessionsList;
                          debug.log('listConnectedSites: $listConnectedSites');
                          setState(() {});
                        },
                        child: SiteWidget(
                          // Display the logo of the site
                          logo: sessionData.peer.metadata.icons.first,
                          // Display the name of the site
                          siteName: sessionData.peer.metadata.name,
                          // Display the URL of the site
                          siteUrl: sessionData.peer.metadata.url,
                          // Pass the app theme to the widget
                          appTheme: appTheme,
                        ),
                      );
                    },
                    // Specify whether more items can be loaded
                    canLoadMore: false,
                  ),
                ),
                // Display a button for initiating a new connection
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      backGroundColor: appTheme.surfaceColorBrandLight,
                      leading: SvgPicture.asset(
                        AssetIconPath.connectSiteQr,
                      ),
                      text: localization.translate(
                        LanguageKey.connectSiteScreenNewConnection,
                      ),
                      // Handle tap on the button
                      onPress: () {
                        // Perform action when the button is tapped
                        // Example:
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => NewConnectionScreen(),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
