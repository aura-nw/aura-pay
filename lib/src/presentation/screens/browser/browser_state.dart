import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser/browser_screen.dart';

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
    Browser? currentBrowser,
    BrowserScreenOptionArgument? option,
  }) {
    return BrowserState(
      status: status ?? this.status,
      tabCount: tabCount ?? this.tabCount,
      accounts: accounts ?? this.accounts,
      currentUrl: url ?? currentUrl,
      bookMark: null,
      canGoNext: canGoNext ?? this.canGoNext,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      option: option ?? this.option,
      currentBrowser: currentBrowser ?? this.currentBrowser,
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
    Browser? currentBrowser,
    @Default('') String currentUrl,
    @Default(false) bool canGoNext,
    @Default(1) int tabCount,
    required BrowserScreenOptionArgument option,
  }) = _BrowserState;
}
