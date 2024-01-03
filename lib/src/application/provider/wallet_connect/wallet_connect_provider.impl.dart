import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/i_botton_sheet_service.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wc_request_widget/wc_request_widget.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'dart:developer' as developer;

import 'wc_connection_request/wc_connection_request_widget.dart';
import 'wc_connection_request/wc_session_request_model.dart';

class WalletConnectProviderImpl {
  late Web3Wallet _web3Wallet;
  static const String projectId = 'a2c114bca03d3d9baedd1012bda2fd89';

  WalletConnectProviderImpl() {
    print('WalletConnectProviderImpl init');
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
  }

  @override
  Future<void> init() async {
    print('WalletConnectProviderImpl init 2');
    await _web3Wallet.init();

    _web3Wallet.registerEventEmitter(
        chainId: 'cosmos:euphoria-2', event: 'chainChanged');
    _web3Wallet.registerEventEmitter(
        chainId: 'cosmos:euphoria-2', event: 'accountsChanged');

    _web3Wallet.registerRequestHandler(
        chainId: 'cosmos:euphoria-2', method: 'cosmos_signDirect');

    _web3Wallet.registerRequestHandler(
        chainId: 'cosmos:euphoria-2', method: 'cosmos_getAccounts');

    _web3Wallet.registerRequestHandler(
        chainId: 'cosmos:euphoria-2', method: 'cosmos_signAmino');

    // Setup our accounts
    _web3Wallet.registerAccount(
      chainId: 'cosmos:euphoria-2',
      accountAddress: '0xeaa05f75445a4beacc73e8fbf07ddb3a76a80a0c',
    );

    // Setup our listeners
    print('web3wallet create');
    _web3Wallet.core.pairing.onPairingInvalid.subscribe(_onPairingInvalid);
    _web3Wallet.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
    _web3Wallet.pairings.onSync.subscribe(_onPairingsSync);
    _web3Wallet.onSessionProposal.subscribe(_onSessionProposal);
    _web3Wallet.onSessionProposalError.subscribe(_onSessionProposalError);
    _web3Wallet.onSessionConnect.subscribe(_onSessionConnect);
    _web3Wallet.onSessionRequest.subscribe(_onSessionRequest);
    _web3Wallet.onAuthRequest.subscribe(_onAuthRequest);
    _web3Wallet.core.relayClient.onRelayClientError
        .subscribe(_onRelayClientError);
  }

  @override
  Future<void> connect(
      {required String uri,
      required Function(SessionProposalEvent event) callBack,
      required Fuc}) async {
    print('WalletConnectProviderImpl connect $uri');
    print(
        'WalletConnectProviderImpl connect _web3Wallet ${_web3Wallet.authKeys}');
    try {
      final Uri uriData = Uri.parse(uri);
      await _web3Wallet.init();
      await _web3Wallet.pair(
        uri: uriData,
      );
    } catch (e, stackTrace) {
      developer.log(e.toString(), stackTrace: stackTrace);
      throw AppError(
        code: AppErrorCodes.walletConnectError,
        message: e.toString(),
      );
    }
  }

  @override
  void onCallRequest() {
    // TODO: implement onCallRequest
  }

  @override
  void onConnect() {
    // TODO: implement onConnect
  }

  @override
  void onDisconnect() {
    // TODO: implement onDisconnect
  }

  @override
  void onSessionRequest() {
    // TODO: implement onSessionRequest
  }

  Future<void> onDispose() async {
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

  void _onPairingsSync(StoreSyncEvent? args) {
    print('#KhoaHM _onPairingsSync $args');
    if (args != null) {}
  }

  void _onRelayClientError(ErrorEvent? args) {
    print('#KhoaHM _onRelayClientError $args');
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) {
    print('#KhoaHM _onSessionProposalError $args');
  }

  void _onSessionProposal(SessionProposalEvent? args) async {
    print('#KhoaHM _onSessionProposal $args');
    if (args != null) {
      final Widget w = WCRequestWidget(
        child: WCConnectionRequestWidget(
          wallet: _web3Wallet,
          sessionProposal: WCSessionRequestModel(
            request: args.params,
            verifyContext: args.verifyContext,
          ),
        ),
      );
      IBottomSheetService bottomSheetHandler = GetIt.I<IBottomSheetService>();
      final bool? approved = await bottomSheetHandler.queueBottomSheet(
        widget: w,
      );
      // print('approved: $approved');

      if (approved != null && approved) {
        _web3Wallet!.approveSession(
          id: args.id,
          namespaces: args.params.generatedNamespaces!,
        );
      } else {
        _web3Wallet!.rejectSession(
          id: args.id,
          reason: Errors.getSdkError(
            Errors.USER_REJECTED,
          ),
        );
      }
    }
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    print('#KhoaHM _onPairingInvalid $args');
  }

  void _onPairingCreate(PairingEvent? args) {
    print('#KhoaHM _onPairingCreate $args');
  }

  void _onSessionRequest(SessionRequestEvent? args) {
    if (args == null) return;
  }

  void _onSessionConnect(SessionConnect? args) {
    if (args != null) {
      print(args);
    }
  }

  Future<void> _onAuthRequest(AuthRequest? args) async {
    if (args != null) {
      print(args);
    }
  }
}
