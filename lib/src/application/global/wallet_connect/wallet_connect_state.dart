import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_connect_state.freezed.dart';

enum WalletConnectStatus { onConnect, onRequest, none }

@freezed
class WalletConnectState with _$WalletConnectState {
  const factory WalletConnectState({
    @Default(WalletConnectStatus.none) WalletConnectStatus status,
    Object? data,
    String? error,
  }) = _WalletConnectState;
}
