import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/history_page_state.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/widgets/transaction_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';
import 'history_page_event.dart';
import 'history_page_selector.dart';
import 'history_page_bloc.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'widgets/account_widget.dart';
import 'widgets/tab_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryPageBloc _bloc = getIt.get<HistoryPageBloc>();

  @override
  void initState() {
    _bloc.add(
      const HistoryPageEventOnInit(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: Scaffold(
            appBar: AppBarWithOnlyTitle(
              appTheme: appTheme,
              titleKey: LanguageKey.transactionHistoryPageAppBarTitle,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.spacing04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing07,
                    ),
                    child: HomeScreenAccountsSelector(
                      builder: (accounts) {
                        final account = accounts.first;
                        return HistoryAccountWidget(
                          onShowMoreAccount: () {},
                          appTheme: appTheme,
                          address: account.address,
                          accountName: account.name,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize07,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing07,
                    ),
                    child: HistoryTabBarWidget(
                      appTheme: appTheme,
                      onChange: (index) {
                        _bloc.add(
                          HistoryPageEventOnFilter(
                            index,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize05,
                  ),
                  const HoLiZonTalDividerWidget(),
                  const SizedBox(
                    height: BoxSize.boxSize05,
                  ),
                  Expanded(
                    child: HistoryPageStatusSelector(
                      builder: (status) {
                        switch (status) {
                          case HistoryPageStatus.loading:
                            return Center(
                              child: AppLoadingWidget(
                                appTheme: appTheme,
                              ),
                            );
                          case HistoryPageStatus.loaded:
                          case HistoryPageStatus.error:
                          case HistoryPageStatus.loadMore:
                          case HistoryPageStatus.refresh:
                            return HistoryPageTransactionsSelector(
                              builder: (transactions) {
                                if (transactions.isEmpty) {
                                  return Center(
                                    child: AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return Text(
                                          localization.translate(
                                            LanguageKey
                                                .transactionHistoryPageNoTransactionFound,
                                          ),
                                          style: AppTypoGraPhy.body02.copyWith(
                                            color: appTheme.contentColor500,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return HistoryPageCanLoadMoreSelector(
                                  builder: (canLoadMore) {
                                    return CombinedListView(
                                      onRefresh: () => _bloc.add(
                                        const HistoryPageEventOnRefresh(),
                                      ),
                                      onLoadMore: () {
                                        if (canLoadMore) {
                                          _bloc.add(
                                            const HistoryPageEventOnLoadMore(),
                                          );
                                        }
                                      },
                                      data: transactions,
                                      builder: (transaction) {
                                        String sender = transaction.events[0];

                                        String type =
                                            AppLocalizationManager.of(context)
                                                .translate(
                                          LanguageKey
                                              .transactionHistoryPageReceive,
                                        );

                                        String iconPath =
                                            AssetIconPath.historyReceiveLogo;


                                        bool isSend = sender == _bloc.state.address;

                                        if (isSend) {
                                          type =
                                              AppLocalizationManager.of(context)
                                                  .translate(
                                            LanguageKey
                                                .transactionHistoryPageSend,
                                          );

                                          iconPath =
                                              AssetIconPath.historySendLogo;
                                        }
                                        return TransactionWidget(
                                          onTap: (){
                                            _showTransactionDetail(transaction);
                                          },
                                          type: type,
                                          iconPath: iconPath,
                                          status: transaction.isSuccess,
                                          amount: transaction.amount?.formatAura  ?? '',
                                          time: transaction.timeStamp,
                                          appTheme: appTheme,
                                          isReceive: !isSend,
                                        );
                                      },
                                      canLoadMore: canLoadMore,
                                    );
                                  },
                                );
                              },
                            );
                        }
                      },
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

  void _showTransactionDetail(PyxisTransaction transaction){

  }
}
