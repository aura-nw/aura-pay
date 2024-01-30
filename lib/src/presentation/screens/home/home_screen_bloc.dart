import 'dart:async';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/debounce.dart';
import 'home_screen_event.dart';

import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;

  HomeScreenBloc(
    this._accountUseCase,
    this._controllerKeyUseCase,
    this._authUseCase,
    this._deviceManagementUseCase,
  ) : super(
          const HomeScreenState(),
        ) {
    on(_init);
    on(_reFetchAccounts);
    on(_onRenameAccount);
    on(_onRemoveAccount);
    on(_onChooseAccount);

    _denounce.addObserver(_onRefreshToken);
  }

  void _onRefreshToken(Map<String, dynamic> data) async {
    try {
      // final String privateKey = data['private_key'];
      // final String address = data['address'];
      //
      // final String accessToken = await AuthHelper.signIn(
      //   authUseCase: _authUseCase,
      //   deviceManagementUseCase: _deviceManagementUseCase,
      //   privateKey: AuraWalletHelper.getPrivateKeyFromString(
      //     privateKey,
      //   ),
      //   walletAddress: address,
      // );
      //
      // await AuthHelper.saveTokenByWalletAddress(
      //   authUseCase: _authUseCase,
      //   walletAddress: address,
      //   accessToken: accessToken,
      // );
    } catch (e) {
      LogProvider.log(e.toString());
    }
  }

  final Denounce<Map<String, dynamic>> _denounce = Denounce(
    const Duration(
      seconds: 2,
    ),
  );

  void _onRenameAccount(
    HomeScreenEventOnRenameAccount event,
    Emitter<HomeScreenState> emit,
  ) async {
    await _accountUseCase.updateAccount(
      accountName: event.name,
      id: event.id,
    );

    add(
      const HomeScreenEventOnReFetchAccount(),
    );
  }

  void _onRemoveAccount(
    HomeScreenEventOnRemoveAccount event,
    Emitter<HomeScreenState> emit,
  ) async {
    final firstAccount = state.accounts.firstOrNull;

    if (firstAccount?.id == event.id) {
      if (state.accounts.length > 1) {
        final account = state.accounts[1];
        emit(state.copyWith(
          selectedAccount: account,
        ));

        final String? privateKey = await _controllerKeyUseCase.getKey(
          address: account.address,
        );

        _denounce.onDenounce({
          'private_key': privateKey,
          'address': account.address,
        });

        await _accountUseCase.updateChangeIndex(
          id: account.id,
        );

        add(
          HomeScreenEventOnChooseAccount(
            state.accounts[1],
          ),
        );
      }
    }

    await _accountUseCase.deleteAccount(
      event.id,
    );

    await _controllerKeyUseCase.deleteKey(
      address: event.address,
    );

    // await AuthHelper.removeCurrentToken(
    //   authUseCase: _authUseCase,
    //   walletAddress: event.address,
    // );

    add(
      const HomeScreenEventOnReFetchAccount(),
    );
  }

  void _init(
    HomeScreenEventOnInit event,
    Emitter<HomeScreenState> emit,
  ) async {
    emit(state.copyWith(
      status: HomeScreenStatus.loading,
    ));
    try {
      final accounts = await _accountUseCase.getAccounts();

      emit(state.copyWith(
        status: HomeScreenStatus.loaded,
        accounts: accounts,
        selectedAccount: accounts.firstWhereOrNull(
          (e) => e.index == 0,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeScreenStatus.error,
      ));
    }
  }

  void _reFetchAccounts(
    HomeScreenEventOnReFetchAccount event,
    Emitter<HomeScreenState> emit,
  ) async {
    final accounts = await _accountUseCase.getAccounts();

    _broadcastChange();

    emit(state.copyWith(
      accounts: accounts,
      selectedAccount: accounts.firstWhereOrNull(
        (e) => e.index == 0,
      ),
    ));
  }

  void _onChooseAccount(
    HomeScreenEventOnChooseAccount event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (event.account.id == state.selectedAccount?.id) return;

    emit(state.copyWith(
      selectedAccount: event.account,
    ));

    final String? privateKey = await _controllerKeyUseCase.getKey(
      address: event.account.address,
    );

    _denounce.onDenounce({
      'private_key': privateKey,
      'address': event.account.address,
    });

    await _accountUseCase.updateChangeIndex(
      id: event.account.id,
    );

    add(
      const HomeScreenEventOnReFetchAccount(),
    );
  }

  // Register callback
  VoidCallback? _broadCast;

  void _broadcastChange() {
    _broadCast?.call();
  }

  void registerCallBack(VoidCallback callback) {
    _broadCast = callback;
  }

  void _removeCallBack() {
    _broadCast = null;
  }

  @override
  Future<void> close() {
    _removeCallBack();
    _denounce.removeObserver(_onRefreshToken);
    return super.close();
  }

  static HomeScreenBloc of(BuildContext context) => BlocProvider.of(context);
}
