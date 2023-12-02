import 'package:flutter/material.dart';

import 'app_global_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppGlobalCubit extends Cubit<AppGlobalState> {
  AppGlobalCubit() : super(const AppGlobalState());

  void changeState(AppGlobalState newState) {
    if (newState.status != state.status) {
      emit(newState);
    }
  }

  void addNewAccount(GlobalActiveAccount account) {
    if (!state.accounts
        .map((e) => e.address)
        .toList()
        .contains(account.address)) {
      emit(
        state.copyWith(
          accounts: [
            ...state.accounts,
            account,
          ],
        ),
      );
    }
  }

  static AppGlobalCubit of(BuildContext context) =>
      BlocProvider.of<AppGlobalCubit>(context);
}
