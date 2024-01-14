import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signed_in_recover_choice_event.dart';
import 'signed_in_recover_choice_state.dart';

class SignedInRecoverChoiceBloc
    extends Bloc<SignedInRecoverChoiceEvent, SignedInRecoverChoiceState> {
  final Web3AuthUseCase _authUseCase;

  SignedInRecoverChoiceBloc(this._authUseCase)
      : super(
          const SignedInRecoverChoiceState(),
        ) {
    on(_onLoginWithGoogle);
  }

  void _onLoginWithGoogle(SignedInRecoverChoiceEventOnGoogleSignIn event,
      Emitter<SignedInRecoverChoiceState> emit) async {
    emit(
      state.copyWith(
        status: SignedInRecoverChoiceStatus.onLogin,
      ),
    );

    try {
      final GoogleAccount? account = await _authUseCase.onLogin();

      if (account != null) {
        emit(
          state.copyWith(
            status: SignedInRecoverChoiceStatus.loginSuccess,
            googleAccount: account,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SignedInRecoverChoiceStatus.loginFailure,
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
          status: SignedInRecoverChoiceStatus.loginFailure,
          errorMessage: errMsg,
        ),
      );
    }
  }
}
