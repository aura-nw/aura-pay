import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_event.dart';
import 'widgets/home_pick_account_widget.dart';
import 'widgets/token_item_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
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
                      return HomeScreenSelectedAccountSelector(
                          builder: (selectedAccount) {
                        return AccountCardWidget(
                          address: selectedAccount?.address ?? '',
                          accountName: selectedAccount?.name ?? '',
                          appTheme: appTheme,
                          onShowMoreAccount: () {
                            _showManageAccount(
                              appTheme,
                              accounts,
                              selectedAccount,
                            );
                          },
                          onCopy: _copyAddress,
                        );
                      });
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

                      _bloc.add(
                        const HomePageEventOnFetchTokenPrice(),
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
                        return HomePageBalanceSelector(builder: (balances) {
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
                                  text:
                                      '  ${(balances.firstOrNull?.amount ?? '').formatTotalPrice(price ?? 0)}',
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
                  HomePageBalanceSelector(
                    builder: (balances) {
                      return HomePagePriceSelector(
                        builder: (price) {
                          if (balances.isEmpty) {
                            return Center(
                              child: EmptyTokenWidget(
                                appTheme: appTheme,
                              ),
                            );
                          }
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
                                    '${localization.translate(LanguageKey.homePageTokenPrefix)} ${(price ?? 0).formatPrice}',
                                balance:
                                    balances.firstOrNull?.amount.formatAura ??
                                        '',
                              );
                            },
                          );
                        },
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

  void _showManageAccount(
    AppTheme appTheme,
    List<AuraAccount> accounts,
    AuraAccount? selectedAccount,
  ) async {
    final AuraAccount? account =
        await DialogProvider.showCustomDialog<AuraAccount>(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: HomePickAccountFormWidget(
        accounts: accounts,
        appTheme: appTheme,
        isSelected: (account) {
          return selectedAccount?.id == account.id;
        },
      ),
    );

    if (selectedAccount?.id == account?.id) return;

    if (account != null && context.mounted) {
      HomeScreenBloc.of(context).add(
        HomeScreenEventOnChooseAccount(
          account,
        ),
      );

      _bloc.add(
        HomePageEventOnFetchTokenPriceWithAddress(
          account.address,
        ),
      );
    }
  }
}
