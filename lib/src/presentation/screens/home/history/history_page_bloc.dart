import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return transactions;
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
          events: [
            "transfer.sender='${account?.address}'",
            "transfer.recipient='${account?.address}'",
          ],
        ),
      );

      // final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          // canLoadMore: transactions.length == 30,
          // transactions: transactions,
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
      ),
    );

    add(
      const HistoryPageEventOnInit(),
    );
  }
}
