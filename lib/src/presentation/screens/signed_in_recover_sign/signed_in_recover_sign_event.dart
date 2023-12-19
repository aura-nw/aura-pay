import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_recover_sign_event.freezed.dart';

@freezed
class SignedInRecoverSignEvent with _$SignedInRecoverSignEvent {
  const factory SignedInRecoverSignEvent.onInit() =
      SignedInRecoverSignEventOnInit;

  const factory SignedInRecoverSignEvent.onChangeFee({
    required String fee,
  }) = SignedInRecoverSignEventOnChangeFee;

  const factory SignedInRecoverSignEvent.onConfirm() =
      SignedInRecoverSignEventOnConfirm;
}
