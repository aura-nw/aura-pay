import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'connect_site_state.dart';
import 'widgets/disconnect_confirmation_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'widgets/connect_site_detail_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'connect_site_cubit.dart';
import 'connect_site_selector.dart';
import 'widgets/site_widget.dart';
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
  final ConnectSiteCubit _cubit = getIt.get<ConnectSiteCubit>();

  void _onRefresh() {
    _cubit.onGetSession();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _cubit,
          child: Scaffold(
            // Define the app bar with title
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey: LanguageKey.connectSiteScreenAppBarTitle,
            ),
            // Define the body of the screen
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing05,
                ),
                child: ConnectSiteStatusSelector(
                  builder: (status) {
                    switch (status) {
                      case ConnectSiteStatus.loading:
                        return Center(
                          child: AppLoadingWidget(
                            appTheme: appTheme,
                          ),
                        );
                      case ConnectSiteStatus.loaded:
                        return Column(
                          children: [
                            Expanded(
                              child: ConnectSiteSessionsSelector(
                                builder: (sessions) {
                                  if (sessions.isEmpty) {
                                    return Center(
                                      child: AppLocalizationProvider(
                                        builder: (localization, _) {
                                          return Text(
                                            localization.translate(
                                              LanguageKey
                                                  .connectSiteScreenNoSiteFound,
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
                                  return CombinedListView<SessionData>(
                                    // Define behavior for refreshing the list
                                    onRefresh: _onRefresh,
                                    // Define behavior for loading more items (if applicable)
                                    onLoadMore: () {},
                                    // Provide the data to be displayed in the list
                                    data: sessions,
                                    // Define the builder function for creating list items
                                    builder: (sessionData, index) {
                                      return GestureDetector(
                                        // Handle tap on the list item
                                        onTap: () async {
                                          _showDetailSite(
                                            sessionData,
                                            appTheme: appTheme,
                                          );
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: SiteWidget(
                                          // Display the logo of the site
                                          logo: sessionData.peer.metadata.icons
                                                  .firstOrNull ??
                                              '',
                                          // Display the name of the site
                                          siteName:
                                              sessionData.peer.metadata.name,
                                          // Display the URL of the site
                                          siteUrl:
                                              sessionData.peer.metadata.url,
                                          // Pass the app theme to the widget
                                          appTheme: appTheme,
                                        ),
                                      );
                                    },
                                    // Specify whether more items can be loaded
                                    canLoadMore: false,
                                  );
                                },
                              ),
                            ),
                            // Display a button for initiating a new connection
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return PrimaryAppButton(
                                  backGroundColor:
                                      appTheme.surfaceColorBrandLight,
                                  leading: SvgPicture.asset(
                                    AssetIconPath.connectSiteQr,
                                  ),
                                  text: localization.translate(
                                    LanguageKey.connectSiteScreenNewConnection,
                                  ),
                                  // Handle tap on the button
                                  onPress: () {},
                                  textStyle:
                                      AppTypoGraPhy.bodyMedium03.copyWith(
                                    color: appTheme.contentColorBrandDark,
                                  ),
                                );
                              },
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

  void _showDetailSite(
    SessionData sessionData, {
    required AppTheme appTheme,
  }) {
    String accountAddress = _cubit.getAddressBySession(sessionData);
    String accountName = _cubit.getAccountNameByAddress(accountAddress);

    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: ConnectSiteDetailFormWidget(
        siteName: sessionData.peer.metadata.name,
        logo: sessionData.peer.metadata.icons.firstOrNull ?? '',
        address: accountAddress,
        url: sessionData.peer.metadata.url,
        accountName: accountName,
        connectType: AppLocalizationManager.of(context).translate(
          LanguageKey.connectSiteScreenConnectionTypeWalletConnect,
        ),
        appTheme: appTheme,
        onDisConnect: () {
          AppNavigator.pop();
          _showConfirmDialog(
            appTheme: appTheme,
            sessionData: sessionData,
            address: accountAddress,
          );
        },
      ),
    );
  }

  void _showConfirmDialog({
    required AppTheme appTheme,
    required SessionData sessionData,
    required String address,
  }) {
    DialogProvider.showRemoveDialog(
      context,
      cancelKey: LanguageKey.connectSiteScreenDisconnectCancelButton,
      confirmKey: LanguageKey.connectSiteScreenDisconnectDisconnectButton,
      content: DisconnectConfirmationContentWidget(
        appTheme: appTheme,
        address: address,
      ),
      onRemove: () {
        _cubit.onDisconnectSession(
          sessionData,
        );
      },
      appTheme: appTheme,
    );
  }
}
