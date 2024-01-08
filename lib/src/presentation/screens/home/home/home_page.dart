import 'dart:io';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'widgets/token_item_widget.dart';
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

  final String _hideTokenText = '********';

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  void _onHoneDropDownClick() {
    _observer.emit(
      emitParam: HomeScreenEmitParam(
        event: HomeScreenObserver.onHomePageDropdownClickEvent,
        data: true,
      ),
    );
  }

  void _listenHomeObserver(HomeScreenEmitParam param) {
    if (param.event == HomeScreenObserver.onSelectedAccountChangeEvent) {
      final data = param.data;

      if (data is AuraAccount) {
        _bloc.add(
          HomePageEventOnFetchTokenPriceWithAddress(
            data.address,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    _observer.addListener(_listenHomeObserver);
    super.initState();
  }

  @override
  void dispose() {
    _observer.removeListener(_listenHomeObserver);
    super.dispose();
  }

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
                            onShowMoreAccount: _onHoneDropDownClick,
                            onCopy: _copyAddress,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize07,
                  ),
                  ChainTriggerWidget(
                    appTheme: appTheme,
                    onNFTsTap: () {
                      AppNavigator.push(
                        RoutePath.nft,
                      );
                    },
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
                  GestureDetector(
                    onTap: () {
                      _bloc.add(
                        const HomePageEventOnHideTokenValue(),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
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
                        const SizedBox(
                          width: BoxSize.boxSize02,
                        ),
                        HomePageHideTokenValueSelector(
                          builder: (hideTokenValue) {
                            return hideTokenValue
                                ? SvgPicture.asset(AssetIconPath.commonEyeHide)
                                : SvgPicture.asset(
                                    AssetIconPath.commonEyeActive,
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize02,
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return HomePagePriceSelector(
                        builder: (price) {
                          return HomePageBalanceSelector(
                            builder: (balances) {
                              return HomePageHideTokenValueSelector(
                                builder: (hideTokenValue) {
                                  return RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: hideTokenValue
                                              ? ''
                                              : localization.translate(
                                                  LanguageKey
                                                      .homePageTokenPrefix,
                                                ),
                                          style:
                                              AppTypoGraPhy.heading03.copyWith(
                                            color: appTheme.contentColorBrand,
                                          ),
                                        ),
                                        TextSpan(
                                          text: hideTokenValue
                                              ? _hideTokenText
                                              : '  ${(balances.firstOrNull?.amount ?? '').formatTotalPrice(price ?? 0)}',
                                          style:
                                              AppTypoGraPhy.heading03.copyWith(
                                            color: appTheme.contentColor700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize07,
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async => _bloc.add(
                            const HomePageEventOnFetchTokenPrice(),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: HomePageBalanceSelector(
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
                                        iconPath:
                                            AssetIconPath.commonAuraTokenLogo,
                                        coin: localization.translate(
                                          LanguageKey.globalPyxisAura,
                                        ),
                                        coinId: localization.translate(
                                          LanguageKey.globalPyxisAuraId,
                                        ),
                                        appTheme: appTheme,
                                        price:
                                            '${localization.translate(LanguageKey.homePageTokenPrefix)} ${(price ?? 0).formatPrice}',
                                        balance: balances
                                                .firstOrNull?.amount.formatAura ??
                                            '',
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
}
