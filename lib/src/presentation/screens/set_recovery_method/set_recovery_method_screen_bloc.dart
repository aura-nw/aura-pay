import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'set_recovery_method_screen_event.dart';
import 'set_recovery_method_screen_state.dart';

final class SetRecoveryMethodScreenBloc
    extends Bloc<SetRecoveryMethodScreenEvent, SetRecoveryMethodScreenState> {
  final Web3AuthUseCase _web3authUseCase;

  SetRecoveryMethodScreenBloc(this._web3authUseCase)
      : super(
          const SetRecoveryMethodScreenState(),
        ) {
    on(_onGoogleLogin);
    on(_onChangeMethod);
  }

  void _onChangeMethod(
    SetRecoveryMethodScreenEventOnChangeMethod event,
    Emitter<SetRecoveryMethodScreenState> emit,
  ) {
    emit(
      state.copyWith(
        status: SetRecoveryMethodScreenStatus.none,
        selectedMethod: event.index,
      ),
    );
  }

  void _onGoogleLogin(
      SetRecoveryMethodScreenEventOnSet event,
    Emitter<SetRecoveryMethodScreenState> emit,
  ) async {
    try {
      // google method default index = 0
      if(state.selectedMethod == 0){
        final account = await _web3authUseCase.onLogin();

        if (account != null) {
          emit(
            state.copyWith(
              status: SetRecoveryMethodScreenStatus.loginSuccess,
              googleAccount: account,
            ),
          );
        }
      }else{
        // backup address
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SetRecoveryMethodScreenStatus.loginFail,
          error: e.toString(),
        ),
      );
    }
  }
}
