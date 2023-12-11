import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'history_page_state.freezed.dart';

enum HistoryPageStatus {
  loading,
  loaded,
  loadMore,
  refresh,
  error,
}

@freezed
class HistoryPageState with _$HistoryPageState {
  const factory HistoryPageState({
    @Default(HistoryPageStatus.loading) HistoryPageStatus status,
    @Default([]) List<PyxisTransaction> transactions,
    @Default(1) int offset,
    @Default(30) int limit,
    @Default([]) List<String> events,
    @Default(false) bool canLoadMore,
    @Default('') String address,
    String ?error,
  }) = _HistoryPageState;
}
