import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/transaction_enum.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'history_page_event.dart';

import 'history_page_state.dart';

final class HistoryPageBloc extends Bloc<HistoryPageEvent, HistoryPageState> {
  final TransactionUseCase _transactionUseCase;
  final AuraAccountUseCase _accountUseCase;

  HistoryPageBloc(
    this._transactionUseCase,
    this._accountUseCase,
  ) : super(
          const HistoryPageState(),
        ) {
    on(_onInit);
    on(_onLoadMore);
    on(_onRefresh);
    on(_onFilter);
    on(_onChangeAccount);
  }

  Future<List<PyxisTransaction>> _getTransaction() async {
    List<PyxisTransaction> transactions = List.empty(growable: true);

    for (final event in state.events) {
      final transactionByEvent = await _transactionUseCase.getTransactions(
        limit: state.limit,
        page: state.offset,
        events: event,
      );

      transactions.addAll(transactionByEvent);
    }

    transactions.sort(
      (a, b) {
        // Default sort as ASC
        return b.timeStamp.compareTo(a.timeStamp);
      },
    );

    return transactions.where(
      (transaction) {
        final MsgType type = TransactionHelper.getMsgType(transaction.msg);

        if (type == MsgType.other) {
          return false;
        }

        if (type == MsgType.executeContract) {
          return TransactionHelper.validateMsgSetRecovery(transaction.msg);
        }

        return true;
      },
    ).toList();
  }

  void _onInit(
    HistoryPageEventOnInit event,
    Emitter<HistoryPageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HistoryPageStatus.loading,
      ),
    );

    try {
      final accounts = await _accountUseCase.getAccounts();

      emit(
        state.copyWith(
          selectedAccount: accounts.firstOrNull,
          accounts: accounts,
          events: _getEventByTab(
            state.currentTab,
            address: accounts.firstOrNull?.address,
          ),
        ),
      );

      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length >= 30,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryPageStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onLoadMore(
    HistoryPageEventOnLoadMore event,
    Emitter<HistoryPageState> emit,
  ) async {
    if (state.status != HistoryPageStatus.loaded) return;

    emit(
      state.copyWith(
        status: HistoryPageStatus.loadMore,
        offset: state.offset + 1,
        events: _getEventByTab(
          state.currentTab,
        ),
      ),
    );

    try {
      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length == 30,
          transactions: [
            ...state.transactions,
            ...transactions,
          ],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryPageStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onRefresh(
    HistoryPageEventOnRefresh event,
    Emitter<HistoryPageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HistoryPageStatus.loading,
        offset: 1,
        transactions: [],
        events: _getEventByTab(
          state.currentTab,
        ),
      ),
    );

    try {
      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length >= 30,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryPageStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onFilter(
    HistoryPageEventOnFilter event,
    Emitter<HistoryPageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HistoryPageStatus.loading,
        offset: 1,
        transactions: [],
        currentTab: event.tab,
        events: _getEventByTab(event.tab),
      ),
    );
    try {
      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length >= 30,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryPageStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onChangeAccount(
    HistoryPageEventOnChangeSelectedAccount event,
    Emitter<HistoryPageState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedAccount: event.selectedAccount,
        events: _getEventByTab(state.currentTab),
      ),
    );

    add(
      const HistoryPageEventOnRefresh(),
    );
  }

  List<List<String>> _getEventByTab(int tab, {String? address}) {
    List<String> querySend = [
      "message.sender='${address ?? state.selectedAccount?.address}'",
      "message.action='${TransactionType.Send}'"
    ];

    List<String> queryReceive = [
      "transfer.recipient='${address ?? state.selectedAccount?.address}'",
    ];

    List<String> querySetRecovery = [
      "message.sender='${address ?? state.selectedAccount?.address}'",
      "message.action='${TransactionType.ExecuteContract}'"
    ];

    List<String> queryRecover = [
      "message.sender='${address ?? state.selectedAccount?.address}'",
      "message.action='${TransactionType.Recover}'"
    ];

    if (tab == 0) {
      return [
        ["message.sender='${address ?? state.selectedAccount?.address}'"],
        ...[
          queryReceive,
        ],
      ];
    } else {
      List<List<String>> events = [
        querySend,
        queryReceive,
        querySetRecovery,
        queryRecover
      ];

      return [
        events[tab - 1],
      ];
    }
  }
}
