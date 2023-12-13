import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_recovery_method_screen_state.freezed.dart';

enum SetRecoveryMethodScreenStatus {
  none,
  loginSuccess,
  loginFail,
}

@freezed
class SetRecoveryMethodScreenState with _$SetRecoveryMethodScreenState {
  const factory SetRecoveryMethodScreenState({
    @Default(SetRecoveryMethodScreenStatus.none)
    SetRecoveryMethodScreenStatus status,
    String ?error,
    GoogleAccount ?googleAccount,
    @Default(0) int selectedMethod,
  }) = _SetRecoveryMethodScreenState;
}
