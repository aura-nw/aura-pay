import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_recover_choice_event.dart';
import 'on_boarding_recover_choice_state.dart';

class OnBoardingRecoverChoiceBloc
    extends Bloc<OnBoardingRecoverChoiceEvent, OnBoardingRecoverChoiceState> {
  final AuthUseCase _authUseCase;

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

    ///
    ///
    try {
      final account = await _authUseCase.onLogin();


      if (account != null) {
        String ?accessToken = await _authUseCase.getCurrentAccessToken();

        emit(
          state.copyWith(
            status: OnBoardingRecoverChoiceStatus.loginSuccess,
            accessToken: accessToken,
          ),
        );

        /// send account information to server get all smart account

        /// if empty show error to user
        /// else direct and show smart accounts for user select.
      }

      /// if false. handle some exception
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: OnBoardingRecoverChoiceStatus.loginFailure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
