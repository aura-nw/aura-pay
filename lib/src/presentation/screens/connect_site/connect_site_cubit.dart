import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/wallet_core/pyxis_wallet_connect_service.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import 'connect_site_state.dart';

class ConnectSiteCubit extends Cubit<ConnectSiteState> {
  final PyxisWalletConnectService _walletConnectService;
  final AuraAccountUseCase _accountUseCase;

  ConnectSiteCubit(this._walletConnectService, this._accountUseCase)
      : super(
          const ConnectSiteState(),
        ) {
    onGetSession();
  }

  void onGetSession() async {
    emit(
      state.copyWith(
        status: ConnectSiteStatus.loading,
        sessions: [],
      ),
    );

    final accounts = await _accountUseCase.getAccounts();
    final sessions = _walletConnectService.sessionsList;

    emit(
      state.copyWith(
        status: ConnectSiteStatus.loaded,
        sessions: sessions,
        accounts: accounts,
      ),
    );
  }

  String getAddressBySession(SessionData sessionData) {
    print('sessionData: $sessionData');
    List<String> listAccount = sessionData.namespaces['cosmos']?.accounts ?? [];
    String accountAddress = '';
    for (var account in listAccount) {
      print('account: $account');
      if (account.startsWith('cosmos:euphoria-2')) {
        accountAddress = account.split('cosmos:euphoria-2:')[1];
        print('Euphoria Account: $accountAddress');
        return accountAddress;
      }
    }
    return '';
  }

  String getAccountNameByAddress(String address) {
    return state.accounts.firstWhereOrNull((e) => e.address == address)?.name ??
        '';
  }

  void onDisconnectSession(SessionData sessionData) async {
    try {
      await _walletConnectService.disconnectSession(
        sessionData,
      );
    } catch (e) {
      LogProvider.log('Disconnect session error ${e.toString()}');
    } finally {
      onGetSession();
    }
  }
}
