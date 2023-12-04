import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_state.freezed.dart';

enum HomeScreenStatus {
  loading,
  loaded,
  error,
}

@freezed
class HomeScreenState with _$HomeScreenState {
  const factory HomeScreenState({
    @Default(HomeScreenStatus.loading) HomeScreenStatus status,
    @Default([]) List<AuraAccount> accounts,
  }) = _HomeScreenState;
}
