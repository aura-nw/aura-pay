import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_create_eoa_by_google_state.dart';

class OnBoardingCreateEOAByGoogleCubit
    extends Cubit<OnBoardingCreateEOAByGoogleState> {
  final Web3AuthUseCase _web3authUseCase;

  OnBoardingCreateEOAByGoogleCubit(this._web3authUseCase)
      : super(
          const OnBoardingCreateEOAByGoogleState(),
        );

  void showGooglePicker() async {
    emit(
      state.copyWith(
        status: OnBoardingCreateEOAByGoogleStatus.none,
      ),
    );
    try {
      await _web3authUseCase.onLogin();
      emit(
        state.copyWith(
          status: OnBoardingCreateEOAByGoogleStatus.logged,
        ),
      );
    } catch (e) {
      String errMsg = e.toString();
      if(e is PlatformException){
        errMsg = e.message ?? e.toString();
      }
      emit(
        state.copyWith(
          status: OnBoardingCreateEOAByGoogleStatus.error,
          error: errMsg,
        ),
      );
    }
  }
}
