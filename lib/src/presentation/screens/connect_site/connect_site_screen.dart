import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/connect_site/widgets/site_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';

class ConnectSiteScreen extends StatefulWidget {
  const ConnectSiteScreen({super.key});

  @override
  State<ConnectSiteScreen> createState() => _ConnectSiteScreenState();
}

class _ConnectSiteScreenState extends State<ConnectSiteScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey: LanguageKey.connectSiteScreenAppBarTitle,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing05,
            ),
            child: Column(
              children: [
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
                  child: CombinedListView(
                    onRefresh: () {},
                    onLoadMore: () {},
                    data: [],
                    builder: (p0, p1) {
                      return SiteWidget(
                        logo: 'logo',
                        siteName: 'siteName',
                        siteUrl: 'siteUrl',
                        appTheme: appTheme,
                      );
                    },
                    canLoadMore: false,
                  ),
                ),
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
