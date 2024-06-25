import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_page_bloc.dart';

import 'history_page_state.dart';

final class HistoryPageTransactionHistoryEnumSelector
    extends BlocSelector<HistoryPageBloc, HistoryPageState, TransactionHistoryEnum> {
  HistoryPageTransactionHistoryEnumSelector({
    Key? key,
    required Widget Function(TransactionHistoryEnum) builder,
  }) : super(
          key: key,
          selector: (state) => state.currentTab,
          builder: (_, currentTab) => builder(
            currentTab,
          ),
        );
}

final class HistoryPageStatusSelector
    extends BlocSelector<HistoryPageBloc, HistoryPageState, HistoryPageStatus> {
  HistoryPageStatusSelector({
    Key? key,
    required Widget Function(HistoryPageStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(
            status,
          ),
        );
}

final class HistoryPageTransactionsSelector extends BlocSelector<
    HistoryPageBloc, HistoryPageState, List<PyxisTransaction>> {
  HistoryPageTransactionsSelector({
    Key? key,
    required Widget Function(List<PyxisTransaction>) builder,
  }) : super(
          key: key,
          selector: (state) => state.transactions,
          builder: (_, transactions) => builder(
            transactions,
          ),
        );
}

final class HistoryPageCanLoadMoreSelector
    extends BlocSelector<HistoryPageBloc, HistoryPageState, bool> {
  HistoryPageCanLoadMoreSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.canLoadMore,
          builder: (_, canLoadMore) => builder(
            canLoadMore,
          ),
        );
}

final class HistoryPageAccountsSelector
    extends BlocSelector<HistoryPageBloc, HistoryPageState, List<AuraAccount>> {
  HistoryPageAccountsSelector({
    Key? key,
    required Widget Function(List<AuraAccount>) builder,
  }) : super(
          key: key,
          selector: (state) => state.accounts,
          builder: (_, accounts) => builder(
            accounts,
          ),
        );
}

final class HistoryPageSelectedAccountSelector
    extends BlocSelector<HistoryPageBloc, HistoryPageState, AuraAccount?> {
  HistoryPageSelectedAccountSelector({
    Key? key,
    required Widget Function(AuraAccount?) builder,
  }) : super(
          key: key,
          selector: (state) => state.selectedAccount,
          builder: (_, selectedAccount) => builder(
            selectedAccount,
          ),
        );
}
