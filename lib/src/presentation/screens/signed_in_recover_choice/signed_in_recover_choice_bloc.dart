import 'package:domain/domain.dart';
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

  void _onLoginWithGoogle(SignedInRecoverChoiceEvent event,
      Emitter<SignedInRecoverChoiceState> emit) async {
    emit(
      state.copyWith(
        status: SignedInRecoverChoiceStatus.onLogin,
      ),
    );

    ///
    ///
    try {
      final account = await _authUseCase.onLogin();

      if (account != null) {
        String userPrivateKey = await _authUseCase.getPrivateKey();

        print('User privatek key = ${userPrivateKey}');

        emit(
          state.copyWith(
            status: SignedInRecoverChoiceStatus.loginSuccess,
            accessToken: userPrivateKey,
          ),
        );

        await _authUseCase.onLogout();

        /// send account information to server get all smart account

        /// if empty show error to user
        /// else direct and show smart accounts for user select.
      }

      /// if false. handle some exception
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: SignedInRecoverChoiceStatus.loginFailure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
