import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_transaction_screen_state.freezed.dart';

enum WalletConnectConfirmTransactionStatus {
  none,
  onApprove,
  onApproveSuccess,
}

@freezed
class WalletConnectConfirmTransactionState
    with _$WalletConnectConfirmTransactionState {
  const factory WalletConnectConfirmTransactionState({
    @Default(WalletConnectConfirmTransactionStatus.none)
    WalletConnectConfirmTransactionStatus status,
    @Default('') String transactionFee,
    @Default('') String highTransactionFee,
    @Default('') String lowTransactionFee,
    String? memo,
  }) = _WalletConnectConfirmTransactionState;
}
