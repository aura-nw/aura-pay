import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_connect_state.freezed.dart';

enum WalletConnectStatus {
  onConnect,
  onRequestAuth,
  onRequest,
  none,
}

@freezed
class WalletConnectState with _$WalletConnectState {
  const factory WalletConnectState({
    @Default(WalletConnectStatus.none) WalletConnectStatus status,
    Object? data,
    String? error,
  }) = _WalletConnectState;
}

class ConnectingData {
  final int sessionId;
  final String account;

  ConnectingData(this.sessionId, this.account);
}

class RequestAuthData {
  final int id;
  final String domain;
  final String aud;
  final String version;
  final String nonce;
  final String iat;
  RequestAuthData({
    required this.id,
    required this.domain,
    required this.aud,
    required this.version,
    required this.nonce,
    required this.iat,
  });
}

class RequestSessionData {
  final int id;
  final String topic;
  final String method;
  final String chainId;
  dynamic params;
  RequestSessionData({
    required this.id,
    required this.topic,
    required this.method,
    required this.chainId,
    this.params,
  });
}
