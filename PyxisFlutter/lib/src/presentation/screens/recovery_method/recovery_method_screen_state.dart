import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'recovery_method_screen_state.freezed.dart';

enum RecoveryMethodScreenStatus {
  loading,
  loaded,
  error,
}

@freezed
class RecoveryMethodScreenState with _$RecoveryMethodScreenState {
  const factory RecoveryMethodScreenState({
    @Default(RecoveryMethodScreenStatus.loading)
    RecoveryMethodScreenStatus status,
    @Default([]) List<AuraAccount> accounts,
  }) = _RecoveryMethodScreenState;
}
