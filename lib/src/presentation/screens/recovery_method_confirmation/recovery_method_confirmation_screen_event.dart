import 'package:freezed_annotation/freezed_annotation.dart';

part 'recovery_method_confirmation_screen_event.freezed.dart';

@freezed
class RecoveryMethodConfirmationEvent with _$RecoveryMethodConfirmationEvent {
  const factory RecoveryMethodConfirmationEvent.onChangeFee({
    required String fee,
  }) = RecoveryMethodConfirmationEventOnChangeFee;

  const factory RecoveryMethodConfirmationEvent.onConfirm() =
      RecoveryMethodConfirmationEventOnConfirm;

  const factory RecoveryMethodConfirmationEvent.onInit() =
      RecoveryMethodConfirmationEventOnInit;
}
