import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_page/widgets/account_card_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_page/widgets/chain_trigger_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_page/widgets/empty_token_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: HomeAppBarWidget(
            appTheme: appTheme,
            onNotificationTap: () {},
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountCardWidget(
                  address: 'aura14re...95tscc',
                  accountName: 'Pyxis Account #1',
                  appTheme: appTheme,
                ),
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                ChainTriggerWidget(
                  appTheme: appTheme,
                ),
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return Text(
                          localization.translate(
                            LanguageKey.homePageTotalTokensValue,
                          ),
                          style: AppTypoGraPhy.body02.copyWith(
                            color: appTheme.contentColor500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: localization.translate(
                              LanguageKey.homePageTokenPrefix,
                            ),
                            style: AppTypoGraPhy.heading03.copyWith(
                              color: appTheme.contentColorBrand,
                            ),
                          ),
                          TextSpan(
                            text: '  0.00',
                            style: AppTypoGraPhy.heading03.copyWith(
                              color: appTheme.contentColor700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize09,
                ),
                Center(
                  child: EmptyTokenWidget(
                    appTheme: appTheme,
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
