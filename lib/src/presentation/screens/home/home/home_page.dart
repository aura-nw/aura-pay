import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home/widgets/token_item_widget.dart';
import 'home_page_event.dart';
import 'home_page_selector.dart';
import 'home_page_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_selector.dart';
import 'widgets/account_widget.dart';
import 'widgets/chain_trigger_widget.dart';
import 'widgets/empty_token_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onReceiveTap;

  const HomePage({
    required this.onReceiveTap,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with CustomFlutterToast, TickerProviderStateMixin {
  final HomePageBloc _bloc = getIt.get<HomePageBloc>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: Scaffold(
            appBar: HomeAppBarWidget(
              appTheme: appTheme,
              onNotificationTap: () {},
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing07,
                vertical: Spacing.spacing04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeScreenAccountsSelector(
                    builder: (accounts) {
                      return AccountCardWidget(
                        address: accounts.first.address,
                        accountName: accounts.first.name,
                        appTheme: appTheme,
                        onShowMoreAccount: () {},
                        onCopy: _copyAddress,
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize07,
                  ),
                  ChainTriggerWidget(
                    appTheme: appTheme,
                    onNFTsTap: () {},
                    onReceiveTap: widget.onReceiveTap,
                    onSendTap: () async {
                      await AppNavigator.push(
                        RoutePath.sendTransaction,
                      );
                    },
                    onStakeTap: () {},
                    onTXsLimitTap: () {},
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
                      return HomePagePriceSelector(builder: (price) {
                        return HomePageBalanceSelector(builder: (balance) {
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
                                  text: '  ${balance.formatPrice(price ?? 0)}',
                                  style: AppTypoGraPhy.heading03.copyWith(
                                    color: appTheme.contentColor700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      });
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize07,
                  ),
                  HomePagePriceSelector(builder: (price) {
                    return HomePageBalanceSelector(builder: (balance) {
                      return AppLocalizationProvider(
                          builder: (localization, _) {
                        return TokenItemWidget(
                          iconPath: AssetIconPath.commonAuraTokenLogo,
                          coin: localization.translate(
                            LanguageKey.globalPyxisAura,
                          ),
                          coinId: localization.translate(
                            LanguageKey.globalPyxisAuraId,
                          ),
                          appTheme: appTheme,
                          price:
                              '${localization.translate(LanguageKey.homePageTokenPrefix)} ${balance.formatPrice(price ?? 0)}',
                          balance: balance.formatAura,
                        );
                      });
                    });
                  }),
                  // Center(
                  //   child: EmptyTokenWidget(
                  //     appTheme: appTheme,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _copyAddress(String data) async {
    await Clipboard.setData(
      ClipboardData(text: data),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.globalPyxisCopyMessage,
            {
              'value': 'address',
            },
          ),
        );
      }
    }
  }
}
