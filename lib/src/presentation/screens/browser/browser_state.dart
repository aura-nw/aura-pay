import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'browser_state.freezed.dart';
extension BrowserStateExtension on BrowserState {
  BrowserState copyWithBookMarkNull({
    AuraAccount? selectedAccount,
    int? tabCount,
    List<AuraAccount>? accounts,
    String? url,
    bool? canGoNext,
    Browser? currentBrowser,
  }) {
    return BrowserState(
      tabCount: tabCount ?? this.tabCount,
      accounts: accounts ?? this.accounts,
      currentUrl: url ?? currentUrl,
      bookMark: null,
      canGoNext: canGoNext ?? this.canGoNext,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      currentBrowser: currentBrowser ?? this.currentBrowser,
    );
  }
}

@freezed
class BrowserState with _$BrowserState {
  const factory BrowserState({
    @Default([]) List<AuraAccount> accounts,
    AuraAccount? selectedAccount,
    BookMark? bookMark,
    Browser? currentBrowser,
    @Default('') String currentUrl,
    @Default(false) bool canGoNext,
    @Default(1) int tabCount,
  }) = _BrowserState;
}
