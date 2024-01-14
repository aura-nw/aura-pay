import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_recover_choice_event.dart';
import 'on_boarding_recover_choice_state.dart';

class OnBoardingRecoverChoiceBloc
    extends Bloc<OnBoardingRecoverChoiceEvent, OnBoardingRecoverChoiceState> {
  final Web3AuthUseCase _authUseCase;

  OnBoardingRecoverChoiceBloc(this._authUseCase)
      : super(
          const OnBoardingRecoverChoiceState(
              status: OnBoardingRecoverChoiceStatus.none),
        ) {
    on(_onLoginWithGoogle);
  }

  void _onLoginWithGoogle(OnBoardingRecoverChoiceEvent event,
      Emitter<OnBoardingRecoverChoiceState> emit) async {
    emit(
      state.copyWith(
        status: OnBoardingRecoverChoiceStatus.onLogin,
      ),
    );

    try {
      final GoogleAccount? account = await _authUseCase.onLogin();

      if (account != null) {
        emit(
          state.copyWith(
            status: OnBoardingRecoverChoiceStatus.loginSuccess,
            googleAccount: account,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: OnBoardingRecoverChoiceStatus.loginFailure,
          ),
        );
      }
    } catch (e) {
      String errMsg = e.toString();
      if(e is PlatformException){
        errMsg = e.message ?? e.toString();
      }
      emit(
        state.copyWith(
          status: OnBoardingRecoverChoiceStatus.loginFailure,
          errorMessage: errMsg,
        ),
      );
    }
  }
}
