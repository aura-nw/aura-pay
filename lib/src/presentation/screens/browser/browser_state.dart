import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'browser_state.freezed.dart';

enum BrowserStatus {
  loading,
  loaded,
  error,
}

@freezed
class BrowserState with _$BrowserState {
  const factory BrowserState({
    @Default(BrowserStatus.loading) BrowserStatus status,
    @Default([]) List<AuraAccount> accounts,
    @Default('') String currentUrl,
    @Default(true) bool canGoBack,
    @Default(false) bool canGoNext,
    @Default(1) int tabCount,
  }) = _BrowserState;
}
