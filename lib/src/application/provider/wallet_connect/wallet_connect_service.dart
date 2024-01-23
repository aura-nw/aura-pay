import 'dart:async';
import 'dart:convert';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import 'package:convert/convert.dart';

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

  WalletUseCase? _walletUseCase;

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
    // args.params.generatedNamespaces
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

    // // Load the private key
    // final keys = GetIt.I<IKeyService>().getKeysForChain(getChainId());
    // final credentials = EthPrivateKey.fromHex(keys[0].privateKey);

    // final signedMessage = hex.encode(
    //   credentials.signPersonalMessageToUint8List(
    //     Uint8List.fromList(utf8.encode(message)),
    //   ),
    // );

    // final r = {'id': id, 'result': signedMessage, 'jsonrpc': '2.0'};
    // final response = JsonRpcResponse.fromJson(r);
    // print(r);
    // _web3Wallet?.respondSessionRequest(topic: topic, response: response);
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

  void approveAuthRequest(RequestAuthData requestAuthData) {
    _web3Wallet?.respondAuthRequest(id: requestAuthData.id, iss: '0x12345678');
  }

  void rejectAuthRequest(RequestAuthData requestAuthData) {
    _web3Wallet?.respondAuthRequest(
        id: requestAuthData.id,
        iss: '0x12345678',
        error: Errors.getSdkError(Errors.USER_REJECTED));
  }

  void approveRequest(RequestSessionData requestSessionData) async {
    _walletUseCase ??= getIt.get();
    final topic = requestSessionData.topic;

    String passPhrase =
        "sunset try feed sing blouse ripple slow bonus heart club owner chuckle";

    final wallet =
        await _walletUseCase!.importWallet(privateKeyOrPassPhrase: passPhrase);

    String publicKey = AuraSmartAccountHelper.encodeByte(wallet.publicKey);
    print('publicKey: $publicKey');

    List<Map<String, String>> messages = [
      {
        'algo': 'secp256k1',
        'address': 'aura1wxtnmdyplfv2f56pel7whckl4ka84e9rvus8hu',
        "pubkey": 'AubiROgK4oQKi6ku2UiOvaRALQCFY43it3k0qCkBtMyq',
      }
    ];

    //02e6e244e80ae2840a8ba92ed9488ebda4402d0085638de2b77934a82901b4ccaa

    final r = {
      'id': requestSessionData.id,
      'result': messages,
      'jsonrpc': '2.0'
    };
    final response = JsonRpcResponse.fromJson(r);
    print(r);
    _web3Wallet?.respondSessionRequest(topic: topic, response: response);
  }

  void rejectRequest(RequestSessionData requestSessionData) {}
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
      accountAddress: 'aura1wxtnmdyplfv2f56pel7whckl4ka84e9rvus8hu',
    );
  }

  static String getUtf8Message(String maybeHex) {
    if (maybeHex.startsWith('0x')) {
      final List<int> decoded = hex.decode(
        maybeHex.substring(2),
      );
      return utf8.decode(decoded);
    }

    return maybeHex;
  }
}
