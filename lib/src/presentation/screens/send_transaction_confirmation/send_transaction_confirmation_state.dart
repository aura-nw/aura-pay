import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_transaction_confirmation_state.freezed.dart';

enum SendTransactionConfirmationStatus {
  none,
  loading,
  success,
  error,
}

@freezed
class SendTransactionConfirmationState with _$SendTransactionConfirmationState {
  const factory SendTransactionConfirmationState({
    @Default(SendTransactionConfirmationStatus.none)
    SendTransactionConfirmationStatus status,
    String? errorMsg,
    required AuraAccount sender,
    required String recipient,
    required String amount,
    required String transactionFee,
    required int estimationGas,
    SendTransactionInformation? sendTransactionInformation,
  }) = _SendTransactionConfirmationState;
}
