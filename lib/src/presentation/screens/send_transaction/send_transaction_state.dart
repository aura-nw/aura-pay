import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_transaction_state.freezed.dart';

enum SendTransactionStatus {
  loading,
  loaded,
  error,
  onEstimateFee,
  estimateFeeSuccess,
  estimateFeeError,
}

@freezed
class SendTransactionState with _$SendTransactionState {
  const factory SendTransactionState({
    @Default(SendTransactionStatus.loading) SendTransactionStatus status,
    @Default('') String recipientAddress,
    AuraAccount? sender,
    // Current amount of sender
    @Default('') String balance,
    // Amount to send
    @Default('') String amount,
    String? error,
    @Default(false) bool isReadySubmit,
    @Default('') String estimateFee,
    @Default(0) int gasEstimation,
  }) = _SendTransactionState;
}
