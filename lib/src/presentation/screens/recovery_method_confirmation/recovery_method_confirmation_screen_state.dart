import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recovery_method_confirmation_screen_state.freezed.dart';

enum RecoveryMethodConfirmationStatus {
  none,
  onRecovering,
  onRecoverSuccess,
  onRecoverFail,
}

@freezed
class RecoveryMethodConfirmationState with _$RecoveryMethodConfirmationState {
  const factory RecoveryMethodConfirmationState({
    required AuraAccount account,
    required GoogleAccount googleAccount,
    @Default(RecoveryMethodConfirmationStatus.none)
    RecoveryMethodConfirmationStatus status,
    String ?error,
    @Default('') String transactionFee,
    @Default('') String highTransactionFee,
    @Default('') String lowTransactionFee,
  }) = _RecoveryMethodConfirmationState;
}
