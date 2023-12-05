import 'package:freezed_annotation/freezed_annotation.dart';
part 'send_transaction_event.freezed.dart';

@freezed
class SendTransactionEvent with _$SendTransactionEvent{
  const factory SendTransactionEvent.onInit() = SendTransactionEventOnInit;

  const factory SendTransactionEvent.onChangeRecipientAddress(String address) = SendTransactionEventOnChangeRecipientAddress;

  const factory SendTransactionEvent.onChangeAmount(String amount) = SendTransactionEventOnChangeAmount;
}