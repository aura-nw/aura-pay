import 'package:flutter/material.dart';

import 'app_global_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppGlobalCubit extends Cubit<AppGlobalState> {
  AppGlobalCubit() : super(const AppGlobalState());

  void changeOnBoardingStatus(OnBoardingStatus onBoardingStatus) {
    if(state.onBoardingStatus != onBoardingStatus){
      emit(
        state.copyWith(
          onBoardingStatus: onBoardingStatus,
        ),
      );
    }
  }

  void changeState(AppGlobalState newState) {
    if (newState.status != state.status) {
      emit(newState);
    }
  }

  static AppGlobalCubit of(BuildContext context) =>
      BlocProvider.of<AppGlobalCubit>(context);
}
