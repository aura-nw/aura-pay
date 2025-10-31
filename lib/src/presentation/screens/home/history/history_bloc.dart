import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurapay/src/presentation/screens/home/history/history_event.dart';
import 'package:aurapay/src/presentation/screens/home/history/history_state.dart';
import 'package:aurapay/src/presentation/screens/home/history/models/transaction_history_model.dart';

final class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryState()) {
    on<HistoryOnInitEvent>(_onInit);
    on<HistoryOnSearchEvent>(_onSearch);
    on<HistoryOnRefreshEvent>(_onRefresh);
  }

  void _onInit(
    HistoryOnInitEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HistoryStatus.loading));

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace this with actual API call
      final transactions = _getMockTransactions();

      emit(
        state.copyWith(
          status: HistoryStatus.loaded,
          transactions: transactions,
          filteredTransactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryStatus.error,
          errorMessage: 'Failed to load transactions',
        ),
      );
    }
  }

  void _onSearch(
    HistoryOnSearchEvent event,
    Emitter<HistoryState> emit,
  ) {
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          filteredTransactions: state.transactions,
        ),
      );
      return;
    }

    final filtered = state.transactions.where((transaction) {
      final typeMatch = transaction.typeDisplayName.toLowerCase().contains(query);
      final addressMatch = transaction.address.toLowerCase().contains(query);
      final statusMatch = transaction.statusDisplayName.toLowerCase().contains(query);
      final amountMatch = transaction.displayAmount.toLowerCase().contains(query);

      return typeMatch || addressMatch || statusMatch || amountMatch;
    }).toList();

    emit(
      state.copyWith(
        searchQuery: query,
        filteredTransactions: filtered,
      ),
    );
  }

  void _onRefresh(
    HistoryOnRefreshEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace this with actual API call
      final transactions = _getMockTransactions();

      emit(
        state.copyWith(
          status: HistoryStatus.loaded,
          transactions: transactions,
          filteredTransactions: state.searchQuery.isEmpty
              ? transactions
              : transactions.where((t) {
                  final query = state.searchQuery.toLowerCase();
                  return t.typeDisplayName.toLowerCase().contains(query) ||
                      t.address.toLowerCase().contains(query) ||
                      t.statusDisplayName.toLowerCase().contains(query) ||
                      t.displayAmount.toLowerCase().contains(query);
                }).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryStatus.error,
          errorMessage: 'Failed to refresh transactions',
        ),
      );
    }
  }

  /// Mock data generator - replace with actual API call
  List<TransactionHistoryModel> _getMockTransactions() {
    final now = DateTime.now();

    return [
      TransactionHistoryModel(
        id: '1',
        type: TransactionType.callContract,
        status: TransactionStatus.pending,
        address: '0x598A8...7b02B',
        timestamp: DateTime(now.year, 5, 30, 14, 5),
        hash: '0x598A87b02B',
      ),
      TransactionHistoryModel(
        id: '2',
        type: TransactionType.send,
        status: TransactionStatus.success,
        address: '0x123A8...7b02B',
        amount: '10',
        token: 'AURA',
        timestamp: DateTime(now.year, 5, 30, 14, 5),
        hash: '0x123A87b02B',
      ),
      TransactionHistoryModel(
        id: '3',
        type: TransactionType.send,
        status: TransactionStatus.failed,
        address: '0x456A8...7b02B',
        amount: '10',
        token: 'AURA',
        timestamp: DateTime(now.year, 5, 30, 14, 5),
        hash: '0x456A87b02B',
      ),
      TransactionHistoryModel(
        id: '4',
        type: TransactionType.receive,
        status: TransactionStatus.failed,
        address: '0x789A8...7b02B',
        amount: '10',
        token: 'AURA',
        timestamp: DateTime(now.year, 5, 30, 14, 5),
        hash: '0x789A87b02B',
      ),
      TransactionHistoryModel(
        id: '5',
        type: TransactionType.receive,
        status: TransactionStatus.success,
        address: '0xABCA8...7b02B',
        amount: '10',
        token: 'AURA',
        timestamp: DateTime(now.year, 5, 30, 14, 5),
        hash: '0xABCA87b02B',
      ),
      TransactionHistoryModel(
        id: '6',
        type: TransactionType.receive,
        status: TransactionStatus.success,
        address: '0xDEFA8...7b02B',
        amount: '10',
        token: 'AURA',
        timestamp: DateTime(now.year, 5, 30, 14, 5),
        hash: '0xDEFA87b02B',
      ),
      TransactionHistoryModel(
        id: '7',
        type: TransactionType.receive,
        status: TransactionStatus.success,
        address: '0x111A8...7b02B',
        amount: '10',
        token: 'AURA',
        timestamp: DateTime(now.year, 5, 30, 14, 5),
        hash: '0x111A87b02B',
      ),
    ];
  }
}

