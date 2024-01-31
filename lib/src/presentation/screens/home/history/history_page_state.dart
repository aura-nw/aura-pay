import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/transaction_enum.dart';

part 'history_page_state.freezed.dart';

// Can add more here.
enum TransactionHistoryEnum implements Comparable<TransactionHistoryEnum> {
  all([
    TransactionType.Send,
    TransactionType.ExecuteContract,
    TransactionType.Recover,
  ]),
  send([
    TransactionType.Send,
  ]),
  receive([]),
  executeContract([
    TransactionType.ExecuteContract,
  ]),
  recovery([
    TransactionType.Recover,
  ]);

  final List<String> messages;

  const TransactionHistoryEnum(this.messages);

  QueryTransactionType get convertToQueryType {
    return QueryTransactionType.values[index];
  }

  @override
  int compareTo(TransactionHistoryEnum other) =>
      messages.length - other.messages.length;
}

enum HistoryPageStatus {
  loading,
  loaded,
  loadMore,
  error,
}

@freezed
class HistoryPageState with _$HistoryPageState {
  const factory HistoryPageState({
    @Default(HistoryPageStatus.loading) HistoryPageStatus status,
    @Default([]) List<PyxisTransaction> transactions,
    @Default(TransactionHistoryEnum.all) TransactionHistoryEnum currentTab,
    @Default('') String environment,
    @Default(30) int limit,
    @Default(false) bool canLoadMore,
    @Default([]) List<AuraAccount> accounts,
    AuraAccount? selectedAccount,
    String? error,
  }) = _HistoryPageState;
}
