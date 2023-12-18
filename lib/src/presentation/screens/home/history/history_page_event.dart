import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'history_page_event.freezed.dart';

@freezed
class HistoryPageEvent with _$HistoryPageEvent{
  const factory HistoryPageEvent.onInit() = HistoryPageEventOnInit;
  const factory HistoryPageEvent.onLoadMore() = HistoryPageEventOnLoadMore;
  const factory HistoryPageEvent.onRefresh() = HistoryPageEventOnRefresh;
  const factory HistoryPageEvent.onFilter(int tab) = HistoryPageEventOnFilter;
  const factory HistoryPageEvent.changeAccount(AuraAccount selectedAccount) = HistoryPageEventOnChangeSelectedAccount;
}