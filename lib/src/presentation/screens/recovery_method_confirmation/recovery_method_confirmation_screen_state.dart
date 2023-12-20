import 'package:freezed_annotation/freezed_annotation.dart';

import 'recovery_method_confirmation_screen.dart';

part 'recovery_method_confirmation_screen_state.freezed.dart';

enum RecoveryMethodConfirmationStatus {
  none,
  onRecovering,
  onRecoverSuccess,
  onRecoverFail,
  onUnRegisterRecoverFail,
}

@freezed
class RecoveryMethodConfirmationState with _$RecoveryMethodConfirmationState {
  const factory RecoveryMethodConfirmationState({
    required RecoveryMethodConfirmationArgument argument,
    @Default(RecoveryMethodConfirmationStatus.none)
    RecoveryMethodConfirmationStatus status,
    String? error,
    @Default('') String transactionFee,
    @Default('') String highTransactionFee,
    @Default('') String lowTransactionFee,
  }) = _RecoveryMethodConfirmationState;
}
