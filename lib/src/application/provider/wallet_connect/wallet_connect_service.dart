import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

enum WalletConnectEvent {
  connect,
  sign,
}

class WalletConnectService {
  static const String projectId = '85289c08fad8fae4ca3eb5e525005bf3';

  final Map<WalletConnectEvent, void Function(dynamic)> _call = {};

  void addListener(WalletConnectEvent event, void Function(dynamic) callback) {
    _call[event] = callback;
  }

  Web3Wallet? _web3Wallet;

  /// The list of requests from the dapp
  /// Potential types include, but aren't limited to:
  /// [SessionProposalEvent], [AuthRequest]
  @override
  ValueNotifier<List<PairingInfo>> pairings =
      ValueNotifier<List<PairingInfo>>([]);
  @override
  ValueNotifier<List<SessionData>> sessions =
      ValueNotifier<List<SessionData>>([]);
  @override
  ValueNotifier<List<StoredCacao>> auth = ValueNotifier<List<StoredCacao>>([]);

  Future<void> create() async {
    // Create the web3wallet
    _web3Wallet = Web3Wallet(
      core: Core(
        projectId: projectId,
        logLevel: LogLevel.error,
      ),
      metadata: const PairingMetadata(
        name: 'Example Wallet',
        description: 'Example Wallet',
        url: 'https://walletconnect.com/',
        icons: [
          'https://github.com/WalletConnect/Web3ModalFlutter/blob/master/assets/png/logo_wc.png'
        ],
        redirect: Redirect(
          native: 'myflutterwallet://',
          universal: 'https://walletconnect.com',
        ),
      ),
    );

    await _web3Wallet!.init();

    WalletConnectServiceUtils.registerChain('cosmos:euphoria-2', _web3Wallet!);
    WalletConnectServiceUtils.registerChain('cosmos:cosmoshub-4', _web3Wallet!);
    WalletConnectServiceUtils.registerChain('cosmos:xstaxy-1', _web3Wallet!);

    // Setup our listeners
    print('web3wallet create');
    _web3Wallet!.core.pairing.onPairingInvalid.subscribe(_onPairingInvalid);
    _web3Wallet!.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
    _web3Wallet!.pairings.onSync.subscribe(_onPairingsSync);
    _web3Wallet!.onSessionProposal.subscribe(_onSessionProposal);
    _web3Wallet!.onSessionProposalError.subscribe(_onSessionProposalError);
    _web3Wallet!.onSessionConnect.subscribe(_onSessionConnect);
    _web3Wallet!.onSessionRequest.subscribe(_onSessionRequest);
    _web3Wallet!.onAuthRequest.subscribe(_onAuthRequest);
    _web3Wallet!.core.relayClient.onRelayClientError
        .subscribe(_onRelayClientError);
  }

  Future<void> init() async {
    // Await the initialization of the web3wallet
    print('web3wallet init');
    await _web3Wallet!.init();

    pairings.value = _web3Wallet!.pairings.getAll();
    sessions.value = _web3Wallet!.sessions.getAll();
    auth.value = _web3Wallet!.completeRequests.getAll();
  }

  FutureOr onDispose() {
    _web3Wallet!.core.pairing.onPairingInvalid.unsubscribe(_onPairingInvalid);
    _web3Wallet!.pairings.onSync.unsubscribe(_onPairingsSync);
    _web3Wallet!.onSessionProposal.unsubscribe(_onSessionProposal);
    _web3Wallet!.onSessionProposalError.unsubscribe(_onSessionProposalError);
    _web3Wallet!.onSessionConnect.unsubscribe(_onSessionConnect);
    _web3Wallet!.onSessionRequest.unsubscribe(_onSessionRequest);
    _web3Wallet!.onAuthRequest.unsubscribe(_onAuthRequest);
    _web3Wallet!.core.relayClient.onRelayClientError
        .unsubscribe(_onRelayClientError);
  }

  Web3Wallet getWeb3Wallet() {
    return _web3Wallet!;
  }

  void _onPairingsSync(StoreSyncEvent? args) {
    print('#KhoaHM _onPairingsSync $args');
    if (args != null) {
      pairings.value = _web3Wallet!.pairings.getAll();
    }
    onPairingsSync?.call(args);
  }

  void _onRelayClientError(ErrorEvent? args) {
    print('#KhoaHM _onRelayClientError $args');
    debugPrint('[$runtimeType] _onRelayClientError ${args?.error}');
    onRelayClientError?.call(args);
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) {
    print('#KhoaHM _onSessionProposalError $args');
    debugPrint('[$runtimeType] _onSessionProposalError $args');
    onSessionProposalError?.call(args);
  }

  void _onSessionProposal(SessionProposalEvent? args) async {
    print('#KhoaHM _onSessionProposal $args');
    onSessionProposal?.call(args);
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    debugPrint('[$runtimeType] _onPairingInvalid $args');
    onPairingInvalid?.call(args);
  }

  void _onPairingCreate(PairingEvent? args) {
    debugPrint('[$runtimeType] _onPairingCreate $args');
    onPairingCreate?.call(args);
  }

  void _onSessionRequest(SessionRequestEvent? args) {
    print('#KhoaHM _onSessionRequest $args');
    onSessionRequest?.call(args);
  }

  void _onSessionConnect(SessionConnect? args) {
    print('#KhoaHM SessionConnect $args');
    onSessionConnect?.call(args);
  }

  void _onAuthRequest(AuthRequest? args) async {
    print('#KhoaHM _onAuthRequest $args');
    onAuthRequest?.call(args);
  }

  void registerEventCallBack(
      {required void Function(SessionConnect? args) onSessionConnect,
      required void Function(SessionRequestEvent? args) onSessionRequest,
      required void Function(SessionProposalEvent? args) onSessionProposal,
      required void Function(SessionProposalErrorEvent? args)
          onSessionProposalError,
      required void Function(PairingEvent? args) onPairingCreate,
      required void Function(PairingInvalidEvent? args) onPairingInvalid,
      required void Function(ErrorEvent? args) onRelayClientError,
      required void Function(StoreSyncEvent? args) onPairingsSync,
      required void Function(AuthRequest? args) onAuthRequest}) {
    this.onSessionConnect = onSessionConnect;
    this.onSessionRequest = onSessionRequest;
    this.onSessionProposal = onSessionProposal;
    this.onSessionProposalError = onSessionProposalError;
    this.onPairingCreate = onPairingCreate;
    this.onPairingInvalid = onPairingInvalid;
    this.onRelayClientError = onRelayClientError;
    this.onPairingsSync = onPairingsSync;
    this.onAuthRequest = onAuthRequest;
  }

  Function(SessionConnect? args)? onSessionConnect;
  Function(SessionRequestEvent? args)? onSessionRequest;
  Function(SessionProposalEvent? args)? onSessionProposal;
  Function(SessionProposalErrorEvent? args)? onSessionProposalError;
  Function(PairingEvent? args)? onPairingCreate;
  Function(PairingInvalidEvent? args)? onPairingInvalid;
  Function(ErrorEvent? args)? onRelayClientError;
  Function(StoreSyncEvent? args)? onPairingsSync;
  Function(AuthRequest? args)? onAuthRequest;

  void approveConnection(ConnectingData connectingData) {
    _web3Wallet?.approveSession(id: connectingData.sessionId, namespaces: {
      'cosmos': Namespace(accounts: [
        'cosmos:euphoria-2:${connectingData.account}',
        'cosmos:cosmoshub-4:${connectingData.account}',
        'cosmos:xstaxy-1:${connectingData.account}',
      ], methods: [
        'cosmos_signDirect',
        'cosmos_getAccounts',
        'cosmos_signAmino'
      ], events: [
        'chainChanged',
        'accountsChanged'
      ]),
    });
  }

  void rejectConnection(ConnectingData connectingData) {
    _web3Wallet?.rejectSession(
        id: connectingData.sessionId,
        reason: Errors.getSdkError(Errors.USER_REJECTED));
  }
}

class WalletConnectServiceUtils {
  static registerChain(String chainId, Web3Wallet web3wallet) {
    web3wallet.registerEventEmitter(chainId: chainId, event: 'chainChanged');
    web3wallet.registerEventEmitter(chainId: chainId, event: 'accountsChanged');

    web3wallet.registerRequestHandler(
        chainId: chainId, method: 'cosmos_signDirect');

    web3wallet.registerRequestHandler(
        chainId: chainId, method: 'cosmos_getAccounts');

    web3wallet.registerRequestHandler(
        chainId: chainId, method: 'cosmos_signAmino');

    // Setup our accounts
    web3wallet.registerAccount(
      chainId: chainId,
      accountAddress: '0xeaa05f75445a4beacc73e8fbf07ddb3a76a80a0c',
    );
  }
}
