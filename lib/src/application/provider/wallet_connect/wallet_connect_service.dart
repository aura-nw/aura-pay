import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectService {
  static const String projectId = 'a2c114bca03d3d9baedd1012bda2fd89';

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

    WalletConnectUtils.registerChain('cosmos:euphoria-2', _web3Wallet!);
    WalletConnectUtils.registerChain('cosmos:cosmoshub-4', _web3Wallet!);

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

  @override
  Future<void> init() async {
    // Await the initialization of the web3wallet
    print('web3wallet init');
    await _web3Wallet!.init();

    pairings.value = _web3Wallet!.pairings.getAll();
    sessions.value = _web3Wallet!.sessions.getAll();
    auth.value = _web3Wallet!.completeRequests.getAll();
  }

  @override
  FutureOr onDispose() {
    print('web3wallet dispose');
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

  @override
  Web3Wallet getWeb3Wallet() {
    return _web3Wallet!;
  }

  void _onPairingsSync(StoreSyncEvent? args) {
    print('#KhoaHM _onPairingsSync $args');
    if (args != null) {
      pairings.value = _web3Wallet!.pairings.getAll();
    }
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
    print('#KhoaHM _onSessionProposal $args');
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
  }

  void _onSessionConnect(SessionConnect? args) {
    if (args != null) {
      print(args);
      sessions.value.add(args.session);
    }
  }

  Future<void> _onAuthRequest(AuthRequest? args) async {
    print('#KhoaHM _onAuthRequest $args');
  }
}

class WalletConnectUtils {
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
