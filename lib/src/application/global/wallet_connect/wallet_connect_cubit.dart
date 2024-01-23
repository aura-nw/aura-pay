import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wallet_connect_service.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  static const String projectId = '85289c08fad8fae4ca3eb5e525005bf3';

  late Web3Wallet _web3Wallet;
  bool _isInit = false;

  final WalletConnectService _walletConnectService =
      getIt.get<WalletConnectService>();

  String? targetAccount;

  WalletConnectCubit() : super((const WalletConnectState())) {
    // _w[core] SessionID
    _init();
  }
  // This function initializes the WalletConnectService
  Future _init() async {
    // Create the WalletConnectService
    await _walletConnectService.create();
    // Initialize the WalletConnectService
    await _walletConnectService.init();
    // Get the Web3Wallet from the WalletConnectService
    _web3Wallet = _walletConnectService.getWeb3Wallet();
    // Register callbacks for various events in the WalletConnectService
    _walletConnectService.registerEventCallBack(
      onPairingsSync: _onPairingsSync,
      onRelayClientError: _onRelayClientError,
      onSessionProposalError: _onSessionProposalError,
      onSessionProposal: _onSessionProposal,
      onPairingInvalid: _onPairingInvalid,
      onPairingCreate: _onPairingCreate,
      onSessionRequest: _onSessionRequest,
      onSessionConnect: _onSessionConnect,
      onAuthRequest: _onAuthRequest,
    );
    // Set the initialization flag to true
    _isInit = true;
  }

  // This function connects to a wallet using a URL and an account
  Future<void> connect(String url, String account) async {
    // Check if the WalletConnectCubit is initialized
    if (!_isInit) {
      throw Exception('WalletConnectCubit is not init');
    }
    // Set the target account
    targetAccount = account;
    try {
      // Parse the URL into a Uri object
      final Uri uriData = Uri.parse(url);
      // Pair the wallet with the Uri
      await _web3Wallet.pair(
        uri: uriData,
      );
    } catch (e, s) {
      // Print any errors that occur during the connection process
      print('WalletConnectScreen _onConnect error: $e, $s');
    }
  }

  // This function approves a connection using ConnectingData
  Future<void> approveConnection(ConnectingData connectingData) async {
    _walletConnectService.approveConnection(connectingData);
  }

  // This function rejects a connection using ConnectingData
  void rejectConnection(ConnectingData connectingData) {
    _walletConnectService.rejectConnection(connectingData);
  }

  void request() {
    emit(state.copyWith(status: WalletConnectStatus.onRequest));
  }

  void reset() {
    emit(state.copyWith(status: WalletConnectStatus.none));
  }

  Web3Wallet getWeb3Wallet() {
    return _web3Wallet!;
  }

  void _onPairingsSync(StoreSyncEvent? args) {
    print('#KhoaHM _onPairingsSync $args');
  }

  void _onRelayClientError(ErrorEvent? args) {
    print('#KhoaHM _onRelayClientError $args');
    debugPrint('[$runtimeType] _onRelayClientError ${args?.error}');
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) {
    print('#KhoaHM _onSessionProposalError $args');
    debugPrint('[$runtimeType] _onSessionProposalError $args');
  }

  void _onSessionProposal(SessionProposalEvent? args) async {
    print('WalletConnectScreen _onConnect onSessionProposal: $args');

    ConnectingData connectingData =
        ConnectingData(args!.id, targetAccount ?? '');
    emit(state.copyWith(
        status: WalletConnectStatus.onConnect, data: connectingData));
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    debugPrint('[$runtimeType] _onPairingInvalid $args');
  }

  void _onPairingCreate(PairingEvent? args) {
    debugPrint('[$runtimeType] _onPairingCreate $args');
  }

  void _onSessionRequest(SessionRequestEvent? args) {
    print('#KhoaHM _onSessionRequest $args');
    if (args == null) return;

    final id = args.id;
    final topic = args.topic;
    final parameters = args.params;
    final method = args.method;

    RequestSessionData requestSessionData = RequestSessionData(
      id: id,
      topic: topic,
      method: method,
      chainId: args.chainId,
      params: parameters,
    );

    // final String message =
    //     WalletConnectServiceUtils.getUtf8Message(method);

    debugPrint('On session request event: $id, $topic, $method');
    emit(state.copyWith(
        status: WalletConnectStatus.onRequest, data: requestSessionData));
  }

  void _onSessionConnect(SessionConnect? args) {
    print('#KhoaHM SessionConnect $args');
  }

  void _onAuthRequest(AuthRequest? args) async {
    print('#KhoaHM _onAuthRequest $args');
    RequestAuthData requestAuthData = RequestAuthData(
      id: args!.id,
      aud: args.payloadParams.aud,
      domain: args.payloadParams.domain,
      version: args.payloadParams.version,
      nonce: args.payloadParams.nonce,
      iat: args.payloadParams.iat,
    );

    emit(state.copyWith(
        status: WalletConnectStatus.onRequestAuth, data: requestAuthData));
  }

  static WalletConnectCubit of(BuildContext context) =>
      BlocProvider.of<WalletConnectCubit>(context);

  void approveAuthRequest(RequestAuthData requestAuthData) {
    _walletConnectService.approveAuthRequest(requestAuthData);
  }

  void rejectAuthRequest(RequestAuthData requestAuthData) {
    _walletConnectService.rejectAuthRequest(requestAuthData);
  }

  void approveRequest(RequestSessionData requestSessionData) {
    _walletConnectService.approveRequest(requestSessionData);
  }

  void rejectRequest(RequestSessionData requestSessionData) {
    _walletConnectService.rejectRequest(requestSessionData);
  }
}
