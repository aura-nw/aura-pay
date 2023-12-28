import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/app_date_format.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/history_page_state.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/widgets/change_account_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/widgets/transaction_detail_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/widgets/transaction_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'history_page_event.dart';
import 'history_page_selector.dart';
import 'history_page_bloc.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'widgets/account_widget.dart';
import 'widgets/tab_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryPageBloc _bloc = getIt.get<HistoryPageBloc>();

  final HomePageObserver _observer = getIt.get<HomePageObserver>();

  void _listenHomePageUpdateAccount(bool status) async {
    if (status) {
      // update account
      _bloc.add(
        const HistoryPageEventOnUpdateAccount(),
      );
    }
  }

  //
  @override
  void initState() {
    _observer.addListener(_listenHomePageUpdateAccount);
    _bloc.add(
      const HistoryPageEventOnInit(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _observer.removeListener(_listenHomePageUpdateAccount);
    super.dispose();
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
                    child: HistoryPageAccountsSelector(
                      builder: (accounts) {
                        return HistoryPageSelectedAccountSelector(
                          builder: (selectedAccount) {
                            return HistoryAccountWidget(
                              onShowMoreAccount: () {
                                _showMoreAccount(
                                    appTheme, accounts, selectedAccount);
                              },
                              appTheme: appTheme,
                              address: selectedAccount?.address ?? '',
                              accountName: selectedAccount?.name ?? '',
                            );
                          },
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
                                      builder: (transaction, index) {
                                        Widget widget = const SizedBox();

                                        final hasPreviousIndex = transactions
                                            .constantIndex(index - 1);

                                        final String dateFormat =
                                            AppDateTime.formatDateDMMMYYY(
                                          transaction.timeStamp,
                                        );

                                        if (!hasPreviousIndex) {
                                          widget = Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dateFormat,
                                                style: AppTypoGraPhy
                                                    .bodyMedium02
                                                    .copyWith(
                                                  color: appTheme
                                                      .contentColorBlack,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: BoxSize.boxSize06,
                                              ),
                                            ],
                                          );
                                        } else {
                                          final previousItem =
                                              transactions[index - 1];

                                          final String preDateFormat =
                                              AppDateTime.formatDateDMMMYYY(
                                            previousItem.timeStamp,
                                          );

                                          if (preDateFormat != dateFormat) {
                                            widget = Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  dateFormat,
                                                  style: AppTypoGraPhy
                                                      .bodyMedium02
                                                      .copyWith(
                                                    color: appTheme
                                                        .contentColorBlack,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: BoxSize.boxSize06,
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            widget,
                                            TransactionWidget(
                                              key: ValueKey(transaction),
                                              onTap: () {
                                                _showTransactionDetail(
                                                    transaction, appTheme);
                                              },
                                              status: transaction.isSuccess,
                                              msgs: transaction.messages,
                                              time: transaction.timeStamp,
                                              appTheme: appTheme,
                                              accountName: _bloc.state
                                                      .selectedAccount?.name ??
                                                  '',
                                              address: _bloc
                                                      .state
                                                      .selectedAccount
                                                      ?.address ??
                                                  '',
                                            ),
                                          ],
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

  void _showTransactionDetail(
    PyxisTransaction transaction,
    AppTheme appTheme,
  ) {
    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: TransactionDetailWidget(
        appTheme: appTheme,
        pyxisTransaction: transaction,
        accountName: _bloc.state.selectedAccount?.name ?? '',
        address: _bloc.state.selectedAccount?.address ?? '',
      ),
    );
  }

  void _showMoreAccount(
    AppTheme appTheme,
    List<AuraAccount> accounts,
    AuraAccount? selectedAccount,
  ) async {
    final AuraAccount? account =
        await DialogProvider.showCustomDialog<AuraAccount>(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: ChangeAccountFormWidget(
        appTheme: appTheme,
        accounts: accounts,
        isSelected: (account) {
          return account.id == selectedAccount?.id;
        },
      ),
    );

    if (account != null) {
      _bloc.add(
        HistoryPageEventOnChangeSelectedAccount(account),
      );
    }
  }
}
