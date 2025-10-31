import 'package:aurapay/src/presentation/screens/home/history/models/transaction_history_model.dart';

enum HistoryStatus {
  initial,
  loading,
  loaded,
  error,
}

final class HistoryState {
  final HistoryStatus status;
  final List<TransactionHistoryModel> transactions;
  final List<TransactionHistoryModel> filteredTransactions;
  final String searchQuery;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.transactions = const [],
    this.filteredTransactions = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<TransactionHistoryModel>? transactions,
    List<TransactionHistoryModel>? filteredTransactions,
    String? searchQuery,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

