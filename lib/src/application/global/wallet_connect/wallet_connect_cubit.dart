import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/core/utils/debug.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'wallet_connect_state.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'dart:developer' as developer;

class WalletConnectCubit extends Cubit<WalletConnectState> {
  static const String projectId = '85289c08fad8fae4ca3eb5e525005bf3';

  bool _isInit = false;

  final WalletConnectService _walletConnectService =
      getIt.get<WalletConnectService>();

  String? targetAccount;

  final SmartAccountUseCase _smartAccountUseCase =
      getIt.get<SmartAccountUseCase>();
  final ControllerKeyUseCase _controllerKeyUseCase =
      getIt.get<ControllerKeyUseCase>();

  WalletConnectCubit() : super((const WalletConnectState())) {
    // _w[core] SessionID
    _init();
  }

  static WalletConnectCubit of(BuildContext context) =>
      BlocProvider.of<WalletConnectCubit>(context);

  // This function initializes the WalletConnectService
  Future _init() async {
    // Create the WalletConnectService
    await _walletConnectService.create(
      name: 'Pyxis',
      description: 'Pyxis',
      url: 'https://walletconnect.com/',
      icon:
          'https://github.com/WalletConnect/Web3ModalFlutter/blob/master/assets/png/logo_wc.png',
      nativeRedirect: 'pyxis://',
      universalRedirect: 'https://pyxis.finance',
    );

    _walletConnectService.registerChain('cosmos:euphoria-2');
    _walletConnectService.registerChain('cosmos:cosmoshub-4');
    _walletConnectService.registerChain('cosmos:xstaxy-1');

    _walletConnectService.registerAccount(
        'cosmos:euphoria-2', 'aura1wxtnmdyplfv2f56pel7whckl4ka84e9rvus8hu');
    _walletConnectService.registerAccount(
        'cosmos:cosmoshub-4', 'aura1wxtnmdyplfv2f56pel7whckl4ka84e9rvus8hu');
    _walletConnectService.registerAccount(
        'cosmos:xstaxy-1', 'aura1wxtnmdyplfv2f56pel7whckl4ka84e9rvus8hu');

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

    _walletConnectService.preload();

    print('inited');

    // Set the initialization flag to true
    _isInit = true;
  }

  // This function connects to a wallet using a URL and an account
  Future<void> connect(String url) async {
    print('#1 WalletConnectCubit connect $url');

    // Check if the WalletConnectCubit is initialized
    if (!_isInit) {
      throw Exception('WalletConnectCubit is not init');
    }
    // Set the target account
    try {
      // Parse the URL into a Uri object
      final Uri uriData = Uri.parse(url);
      // Pair the wallet with the Uri
      await _walletConnectService.connect(
        uri: uriData,
      );
    } catch (e, s) {
      // Print any errors that occur during the connection process
      print('WalletConnectScreen _onConnect error: $e, $s');
    }
  }

  // This function approves a connection using ConnectingData
  Future<void> approveConnection(ConnectingData connectingData) async {
    String account = await _getAddress();
    _walletConnectService.approveConnection(
        sessionId: connectingData.sessionId, account: account);
  }

  // This function rejects a connection using ConnectingData
  void rejectConnection(ConnectingData connectingData) {
    _walletConnectService.rejectConnection(sessionId: connectingData.sessionId);
  }

  void request() {
    emit(state.copyWith(status: WalletConnectStatus.onRequest));
  }

  void reset() {
    emit(state.copyWith(status: WalletConnectStatus.none));
  }

  void _onPairingsSync(StoreSyncEvent? args) {
    print('#PyxisDebug _onPairingsSync $args');
  }

  void _onRelayClientError(ErrorEvent? args) {
    print('#PyxisDebug _onRelayClientError $args');
    debugPrint('[$runtimeType] _onRelayClientError ${args?.error}');
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) {
    print('#PyxisDebug _onSessionProposalError $args');
    debugPrint('[$runtimeType] _onSessionProposalError $args');
  }

  void _onSessionProposal(SessionProposalEvent? args) async {
    print('#3 WalletConnectCubit _onSessionProposal $args');
    print('WalletConnectScreen _onConnect onSessionProposal: $args');

    String account = await _getAddress();

    ConnectingData connectingData = ConnectingData(
        args!.id,
        account,
        args.params.proposer.metadata.url,
        args.params.proposer.metadata.icons[0]);
    emit(state.copyWith(
        status: WalletConnectStatus.onConnect, data: connectingData));
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    debugPrint('[$runtimeType] _onPairingInvalid $args');
  }

  void _onPairingCreate(PairingEvent? args) {
    debugPrint('[$runtimeType] _onPairingCreate $args');
  }

  void _onSessionRequest(SessionRequestEvent? args) async {
    print('#PyxisDebug _onSessionRequest $args');
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

    if (method == 'cosmos_getAccounts') {
      _walletConnectService.approveRequest(
          id: requestSessionData.id,
          topic: requestSessionData.topic,
          msg: [
            {
              'algo': 'secp256k1',
              'address': _getAddress(),
              "pubkey": await _getPublicKey(),
            }
          ]);

      return;
    }

    // final String message =
    //     WalletConnectServiceUtils.getUtf8Message(method);

    debugPrint('On session request event: $id, $topic, $method');
    emit(state.copyWith(
        status: WalletConnectStatus.onRequest, data: requestSessionData));
  }

  void _onSessionConnect(SessionConnect? args) {
    print('#PyxisDebug SessionConnect $args');
  }

  void _onAuthRequest(AuthRequest? args) async {
    print('#PyxisDebug _onAuthRequest $args');
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

  void approveAuthRequest(RequestAuthData requestAuthData) {
    _walletConnectService.approveAuthRequest(
        id: requestAuthData.id, iss: requestAuthData.version);
  }

  void rejectAuthRequest(RequestAuthData requestAuthData) {
    _walletConnectService.rejectAuthRequest(
        id: requestAuthData.id, iss: requestAuthData.version);
  }

  void approveRequest(RequestSessionData requestSessionData) async {
    if (requestSessionData.method == 'cosmos_signAmino') {
      try {
        Map<String, dynamic> msg = AuraCoreHelper.signAmino(
          signDoc: requestSessionData.params['signDoc'],
          privateKeyHex: await _getPriKey(),
          pubKeyHex: await _getPublicKey(),
        );
        _walletConnectService.approveRequest(
            id: requestSessionData.id,
            topic: requestSessionData.topic,
            msg: msg);
      } catch (e, s) {
        print(e);
        developer.log(e.toString(), stackTrace: s);
      }
      return;
    }

    _walletConnectService.approveRequest(
        id: requestSessionData.id, topic: requestSessionData.topic, msg: []);
  }

  void rejectRequest(RequestSessionData requestSessionData) {
    _walletConnectService.rejectRequest(
        id: requestSessionData.id, topic: requestSessionData.topic);
  }

  void registerSmartAccount(String address) {
    _walletConnectService.registerAccount('cosmos:euphoria-2', address);
    _walletConnectService.registerAccount('cosmos:cosmoshub-4', address);
    _walletConnectService.registerAccount('cosmos:xstaxy-1', address);
  }

  Future<String> _getAddress() async {
    final AuraAccountUseCase useCase = getIt.get<AuraAccountUseCase>();
    var account = await useCase.getFirstAccount();
    targetAccount = account?.address;
    debug.log('targetAccount: $targetAccount');
    return targetAccount ?? '';
  }

  Future<String> _getPublicKey() async {
    // return 'AubiROgK4oQKi6ku2UiOvaRALQCFY43it3k0qCkBtMyq';
    return _smartAccountUseCase.getCosmosPubKeyByAddress(
        address: targetAccount ?? '');
  }

  Future<String> _getPriKey() async {
    // return 'af36a6f38c6775569c9d8ffa73169072d169ae099c069fa3360799863b7bf893';
    final privateKey = await _getPrivateKeyBytes();
    return AuraWalletHelper.getPrivateKeyFromBytes(privateKey);
  }

  Future<Uint8List> _getPrivateKeyBytes() async {
    final String? controllerKey =
        await _controllerKeyUseCase.getKey(address: targetAccount ?? '');
    return AuraWalletHelper.getPrivateKeyFromString(controllerKey ?? '');
  }
}
