import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'set_recovery_method_screen_event.dart';
import 'set_recovery_method_screen_state.dart';

final class SetRecoveryMethodScreenBloc
    extends Bloc<SetRecoveryMethodScreenEvent, SetRecoveryMethodScreenState> {
  final Web3AuthUseCase _web3authUseCase;

  SetRecoveryMethodScreenBloc(
    this._web3authUseCase,
  ) : super(
          const SetRecoveryMethodScreenState(),
        ) {
    on(_onSetRecoveryMethod);
    on(_onChangeMethod);
    on(_onBackupAddressChange);
  }

  void _onBackupAddressChange(
    SetRecoveryMethodScreenEventOnChangeRecoveryAddress event,
    Emitter<SetRecoveryMethodScreenState> emit,
  ) {
    emit(
      state.copyWith(
        status: SetRecoveryMethodScreenStatus.none,
        recoverAddress: event.address,
        isReady: event.isReady,
      ),
    );
  }

  void _onChangeMethod(
    SetRecoveryMethodScreenEventOnChangeMethod event,
    Emitter<SetRecoveryMethodScreenState> emit,
  ) {
    emit(
      state.copyWith(
        status: SetRecoveryMethodScreenStatus.none,
        selectedMethod: event.type,
        recoverAddress: '',
        isReady: event.type == RecoverOptionType.google,
      ),
    );
  }

  void _onSetRecoveryMethod(
    SetRecoveryMethodScreenEventOnSet event,
    Emitter<SetRecoveryMethodScreenState> emit,
  ) async {
    try {
      // google method default index = 0
      if (state.selectedMethod == RecoverOptionType.google) {
        final account = await _web3authUseCase.onLogin();

        if (account != null) {
          emit(
            state.copyWith(
              status: SetRecoveryMethodScreenStatus.loginSuccess,
              googleAccount: account,
            ),
          );
        }
      } else {
        // backup address
        emit(
          state.copyWith(
            status: SetRecoveryMethodScreenStatus.loginSuccess,
          ),
        );
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
