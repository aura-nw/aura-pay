import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/transaction_enum.dart';
import 'history_page_event.dart';

import 'history_page_state.dart';

final class HistoryPageBloc extends Bloc<HistoryPageEvent, HistoryPageState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;

  HistoryPageBloc(
    this._smartAccountUseCase,
    this._accountUseCase,
  ) : super(
          const HistoryPageState(),
        ) {
    on(_onInit);
    on(_onLoadMore);
    on(_onRefresh);
    on(_onFilter);
  }

  Future<List<PyxisTransaction>> _getTransaction() async {
    List<PyxisTransaction> transactions = List.empty(growable: true);
    for (final event in state.events) {
      final transactionByEvent =
          await _smartAccountUseCase.getTransactionHistories(
        limit: state.limit,
        offset: state.offset,
        events: [
          event,
        ],

        /// Default order by
        orderBy: '',
      );

      transactions.addAll(transactionByEvent);
    }

    transactions.sort(
      (a, b) {
        // Default sort as ASC
        return a.timeStamp.compareTo(b.timeStamp);
      },
    );

    return transactions
        .where(
          (element) => element.type == TransactionType.Send,
        )
        .toList();
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
      final account = await _accountUseCase.getFirstAccount();

      emit(
        state.copyWith(
          address: account?.address ?? '',
          events: _getEventByTab(
            0,
            address: account?.address,
          ),
        ),
      );

      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length == 30,
          transactions: transactions,
        ),
      );
    } catch (e) {
      print(e.toString());
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
      ),
    );

    try {
      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length == 30,
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
        events: _getEventByTab(event.tab),
      ),
    );
    try {
      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length == 30,
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

  List<String> _getEventByTab(int tab, {String? address}) {
    // Total tab = 3 include all , send , receive , stake
    final List<String> events = [
      "transfer.sender='${address ?? state.address}'",
      "transfer.recipient='${address ?? state.address}'",
      "stake.sender='${address ?? state.address}'",
    ];

    if (tab == 0) {
      return events;
    } else {
      return [
        events[tab - 1],
      ];
    }
  }
}
