import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'browser_state.freezed.dart';

enum BrowserStatus {
  loading,
  loaded,
  error,
}

extension BrowserStateExtension on BrowserState {
  BrowserState copyWithBookMarkNull({
    AuraAccount? selectedAccount,
    BrowserStatus? status,
    int? tabCount,
    List<AuraAccount>? accounts,
    String? url,
    bool? canGoNext,
  }) {
    return BrowserState(
      status: status ?? this.status,
      tabCount: tabCount ?? this.tabCount,
      accounts: accounts ?? this.accounts,
      currentUrl: url ?? currentUrl,
      bookMark: null,
      canGoNext: canGoNext ?? this.canGoNext,
      selectedAccount: selectedAccount ?? this.selectedAccount,
    );
  }
}

@freezed
class BrowserState with _$BrowserState {
  const factory BrowserState({
    @Default(BrowserStatus.loading) BrowserStatus status,
    @Default([]) List<AuraAccount> accounts,
    AuraAccount? selectedAccount,
    BookMark? bookMark,
    @Default('') String currentUrl,
    @Default(false) bool canGoNext,
    @Default(1) int tabCount,
  }) = _BrowserState;
}
