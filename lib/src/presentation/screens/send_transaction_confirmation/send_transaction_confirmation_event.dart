import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_transaction_confirmation_event.freezed.dart';

@freezed
class SendTransactionConfirmationEvent with _$SendTransactionConfirmationEvent {
  const factory SendTransactionConfirmationEvent.onChangeFee({
    required String fee,
  }) = SendTransactionConfirmationEventOnChangeFee;

  const factory SendTransactionConfirmationEvent.onChangeMemo({
    required String memo,
  }) = SendTransactionConfirmationEventOnChangeMemo;

  const factory SendTransactionConfirmationEvent.onShowFullMessage() = SendTransactionConfirmationEventOnShowFullMessage;

  const factory SendTransactionConfirmationEvent.onInit() = SendTransactionConfirmationEventOnInit;

  const factory SendTransactionConfirmationEvent.onSendToken() =
      SendTransactionConfirmationEventOnSendToken;
}
