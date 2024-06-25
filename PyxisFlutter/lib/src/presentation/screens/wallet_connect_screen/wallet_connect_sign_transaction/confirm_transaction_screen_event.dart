import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';

part 'confirm_transaction_screen_event.freezed.dart';

@freezed
class WalletConnectConfirmTransactionEvent
    with _$WalletConnectConfirmTransactionEvent {
  const factory WalletConnectConfirmTransactionEvent.onChangeFee({
    required String fee,
  }) = WalletConnectConfirmTransactionEventOnChangeFee;

  const factory WalletConnectConfirmTransactionEvent.onChangeMemo({
    required String memo,
  }) = WalletConnectConfirmTransactionEventOnChangeMemo;

  const factory WalletConnectConfirmTransactionEvent.onConfirm(RequestSessionData requestSessionData) =
      WalletConnectConfirmTransactionEventOnConfirm;

  const factory WalletConnectConfirmTransactionEvent.onInit() =
      WalletConnectConfirmTransactionEventOnInit;
}
