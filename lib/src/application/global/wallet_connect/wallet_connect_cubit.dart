import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wallet_connect_service.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  static const String projectId = '85289c08fad8fae4ca3eb5e525005bf3';

  late Web3Wallet _web3Wallet;

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

  final WalletConnectService _walletConnectService =
      GetIt.I.get<WalletConnectService>();

  WalletConnectCubit() : super((const WalletConnectState())) {
    _web3Wallet = _walletConnectService.getWeb3Wallet();
    _walletConnectService.registerEventCallBack(
      onSessionConnect: _onSessionConnect,
      onSessionRequest: _onSessionRequest,
      onSessionProposal: _onSessionProposal,
      onSessionProposalError: _onSessionProposalError,
      onPairingCreate: _onPairingCreate,
      onPairingInvalid: _onPairingInvalid,
      onRelayClientError: _onRelayClientError,
      onPairingsSync: _onPairingsSync,
      onAuthRequest: _onAuthRequest,
    );
  }

  ///
  ///
  Future<void> connect(String url) async {
    try {
      final Uri uriData = Uri.parse(url);
      await _web3Wallet.pair(
        uri: uriData,
      );
    } catch (e, s) {
      print('WalletConnectScreen _onConnect error: $e, $s');
    }
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
    print('WalletConnectScreen _onConnect onSessionProposal: $args');

    // _sessionProposalEvent = args;
    // connectionId = _sessionProposalEvent?.id;
    // setState(() {
    //   _screenState = WalletConnectScreenState.onRequestConnecting;
    // });
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
    print('#KhoaHM SessionConnect $args');

    if (args != null) {
      print(args);
      sessions.value.add(args.session);
    }
  }

  Future<void> _onAuthRequest(AuthRequest? args) async {
    print('#KhoaHM _onAuthRequest $args');
  }

  static WalletConnectCubit of(BuildContext context) =>
      BlocProvider.of<WalletConnectCubit>(context);
}
