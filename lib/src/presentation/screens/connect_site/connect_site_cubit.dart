import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import 'connect_site_state.dart';

class ConnectSiteCubit extends Cubit<ConnectSiteState> {
  final WalletConnectService _walletConnectService;

  ConnectSiteCubit(this._walletConnectService)
      : super(
          const ConnectSiteState(),
        ) {
    onGetSession();
  }

  void onGetSession() {
    emit(
      state.copyWith(
        status: ConnectSiteStatus.loading,
        sessions: [],
      ),
    );

    final sessions = _walletConnectService.sessionsList;

    emit(
      state.copyWith(
        status: ConnectSiteStatus.loaded,
        sessions: sessions,
      ),
    );
  }

  void onDisconnectSession(SessionData sessionData) async {
    try {
      await _walletConnectService.disconnectSession(
        sessionData,
      );
    } catch (e) {
      LogProvider.log(
        'Disconnect session error ${e.toString()}'
      );
    } finally {
      onGetSession();
    }
  }
}
