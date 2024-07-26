import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_send_event.freezed.dart';

@freezed
class ConfirmSendEvent with _$ConfirmSendEvent {
  const factory ConfirmSendEvent.init() = ConfirmSendOnInitEvent;

  const factory ConfirmSendEvent.onChangeFee({required String fee}) =
      ConfirmSendOnChangeFeeEvent;

  const factory ConfirmSendEvent.onSubmit() = ConfirmSendOnSubmitEvent;
}
