import 'package:domain/domain.dart';
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
      emit(
        state.copyWith(
          status: OnBoardingCreateEOAByGoogleStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
