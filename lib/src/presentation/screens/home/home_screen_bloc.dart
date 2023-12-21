import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_event.dart';

import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  HomeScreenBloc(
    this._accountUseCase,
    this._controllerKeyUseCase,
  ) : super(
          const HomeScreenState(),
        ) {
    on(_init);
    on(_reFetchAccounts);
    on(_onRenameAccount);
    on(_onRemoveAccount);
    on(_onUChooseAccount);
  }

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
    await _accountUseCase.deleteAccount(
      event.id,
    );

    await _controllerKeyUseCase.deleteKey(
      address: event.address,
    );

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
        selectedAccount: accounts.firstOrNull,
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
    ));
  }

  void _onUChooseAccount(
    HomeScreenEventOnChooseAccount event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (event.account.id == state.selectedAccount?.id) return;

    emit(state.copyWith(
      selectedAccount: event.account,
    ));

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

  @override
  Future<void> close() {
    _broadCast = null;
    return super.close();
  }

  static HomeScreenBloc of(BuildContext context) => BlocProvider.of(context);
}
