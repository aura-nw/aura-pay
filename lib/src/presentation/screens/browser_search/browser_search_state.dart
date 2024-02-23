import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/aura_ecosystem.dart';

part 'browser_search_state.freezed.dart';

@freezed
class BrowserSearchState with _$BrowserSearchState {
  const factory BrowserSearchState({
    @Default(auraEcosystems) List<BrowserInformation> systems,
    @Default('') String query,
  }) = _BrowserSearchState;
}
