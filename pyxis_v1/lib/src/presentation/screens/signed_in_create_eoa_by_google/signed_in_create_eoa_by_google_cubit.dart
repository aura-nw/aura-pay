import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signed_in_create_eoa_by_google_state.dart';

class SignedInCreateEOAByGoogleCubit
    extends Cubit<SignedInCreateEOAByGoogleState> {
  final Web3AuthUseCase _web3authUseCase;

  SignedInCreateEOAByGoogleCubit(this._web3authUseCase)
      : super(
          const SignedInCreateEOAByGoogleState(),
        );

  void showGooglePicker() async {
    emit(
      state.copyWith(
        status: SignedInCreateEOAByGoogleStatus.none,
      ),
    );
    try {
      await _web3authUseCase.onLogin();
      emit(
        state.copyWith(
          status: SignedInCreateEOAByGoogleStatus.logged,
        ),
      );
    } catch (e) {
      String errMsg = e.toString();
      if(e is PlatformException){
        errMsg = e.message ?? e.toString();
      }
      emit(
        state.copyWith(
          status: SignedInCreateEOAByGoogleStatus.error,
          error: errMsg,
        ),
      );
    }
  }
}
