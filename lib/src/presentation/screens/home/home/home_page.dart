import 'dart:io';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
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
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_event.dart';
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
    final HomeScreenBloc homeScreenBloc = HomeScreenBloc.of(
      context,
    );

    AppNavigator.push(
      RoutePath.accounts,
      homeScreenBloc,
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
    } else if (param.event == HomeScreenObserver.onSendTokenSuccessFulEvent) {
      _bloc.add(
        const HomePageEventOnFetchTokenPrice(),
      );
    } else if (param.event ==
        HomeScreenObserver.onSetRecoveryMethodSuccessfulEvent) {
      _bloc.add(
        const HomePageEventOnFetchTokenPrice(),
      );
    } else if (param.event == HomeScreenObserver.onRecoverSuccessfulEvent) {
      _bloc.add(
        const HomePageEventOnFetchTokenPrice(),
      );
    }else if(param.event == HomeScreenObserver.onInAppBrowserChooseAccountEvent){
      final data = param.data;

      if (data is AuraAccount) {
        HomeScreenBloc.of(
          context,
        ).add(
          HomeScreenEventOnChooseAccount(
            data,
          ),
        );
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

  void _listenOnBoardingStatus() async {
    await Future.delayed(const Duration(
      milliseconds: 1100,
    ));

    if (context.mounted) {
      final state = AppGlobalCubit.of(context).state;

      switch (state.onBoardingStatus) {
        case OnBoardingStatus.none:
          break;
        case OnBoardingStatus.importSmartAccountSuccessFul:
          showToast(
            AppLocalizationManager.of(context).translate(
              LanguageKey.homeScreenImportAccountSuccessFul,
            ),
          );

          AppGlobalCubit.of(context)
              .changeOnBoardingStatus(OnBoardingStatus.none);
          break;
        case OnBoardingStatus.recoverSmartAccountSuccess:
          showToast(
            AppLocalizationManager.of(context).translate(
              LanguageKey.homeScreenRecoverSmartAccountSuccessFul,
            ),
          );

          AppGlobalCubit.of(context)
              .changeOnBoardingStatus(OnBoardingStatus.none);
          break;
        case OnBoardingStatus.createSmAccountSuccess:
          showToast(
            AppLocalizationManager.of(context).translate(
              LanguageKey.homeScreenCreateSmartAccountSuccessFul,
            ),
          );
          AppGlobalCubit.of(context)
              .changeOnBoardingStatus(OnBoardingStatus.none);
          break;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listenOnBoardingStatus();
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
              chainName: getIt.get<PyxisMobileConfig>().chainName,
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
                    onSiteTap: () {
                      AppNavigator.push(
                        RoutePath.settingConnectSite,
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
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
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
                                      return HomePageHideTokenValueSelector(
                                        builder: (hideTokenValue) {
                                          return TokenItemWidget(
                                            iconPath: AssetIconPath
                                                .commonAuraToken,
                                            coin: localization.translate(
                                              LanguageKey.globalPyxisAura,
                                            ),
                                            coinId: localization.translate(
                                              LanguageKey.globalPyxisAuraId,
                                            ),
                                            appTheme: appTheme,
                                            price: hideTokenValue
                                                ? _hideTokenText
                                                : '${localization.translate(LanguageKey.homePageTokenPrefix)} ${(price ?? 0).formatPrice}',
                                            balance: hideTokenValue
                                                ? _hideTokenText
                                                : balances.firstOrNull?.amount
                                                        .formatAura ??
                                                    '',
                                          );
                                        },
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
