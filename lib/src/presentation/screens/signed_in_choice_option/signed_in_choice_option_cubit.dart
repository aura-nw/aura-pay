import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'signed_in_choice_option_state.dart';

class SignedInChoiceOptionCubit extends Cubit<SignedInChoiceOptionState> {
  final Web3AuthUseCase _web3authUseCase;

  SignedInChoiceOptionCubit(this._web3authUseCase)
      : super(
          const SignedInChoiceOptionState(),
        );

  void onRecoverAccountClick() async {
    emit(
      state.copyWith(
        status: SignedInChoiceOptionStatus.onLogin,
      ),
    );

    try {
      final GoogleAccount? account = await _web3authUseCase.onLogin();

      if (account != null) {
        emit(
          state.copyWith(
            status: SignedInChoiceOptionStatus.loginSuccess,
            googleAccount: account,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SignedInChoiceOptionStatus.loginFailure,
          ),
        );
      }
    } catch (e) {
      String errMsg = e.toString();
      if (e is PlatformException) {
        errMsg = e.message ?? e.toString();
      }
      emit(
        state.copyWith(
          status: SignedInChoiceOptionStatus.loginFailure,
          errorMessage: errMsg,
        ),
      );
    }
  }
}
