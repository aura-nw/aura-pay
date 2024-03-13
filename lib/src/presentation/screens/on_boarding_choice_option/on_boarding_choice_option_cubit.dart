import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_choice_option_state.dart';

class OnBoardingChoiceOptionCubit extends Cubit<OnBoardingChoiceOptionState> {
  final Web3AuthUseCase _web3authUseCase;

  OnBoardingChoiceOptionCubit(this._web3authUseCase)
      : super(
          const OnBoardingChoiceOptionState(),
        );

  void onRecoverAccountClick() async {
    emit(
      state.copyWith(
        status: OnBoardingChoiceOptionStatus.onLogin,
      ),
    );

    try {
      final GoogleAccount? account = await _web3authUseCase.onLogin();

      if (account != null) {
        emit(
          state.copyWith(
            status: OnBoardingChoiceOptionStatus.loginSuccess,
            googleAccount: account,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: OnBoardingChoiceOptionStatus.loginFailure,
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
          status: OnBoardingChoiceOptionStatus.loginFailure,
          errorMessage: errMsg,
        ),
      );
    }
  }
}
