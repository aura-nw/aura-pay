import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_event.dart';

import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final AuraAccountUseCase _accountUseCase;

  HomeScreenBloc(this._accountUseCase)
      : super(
          const HomeScreenState(),
        ) {
    on(_init);
    on(_reFetchAccounts);
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

    emit(state.copyWith(
      accounts: accounts,
    ));
  }

  static HomeScreenBloc of(BuildContext context) => BlocProvider.of(context);
}
