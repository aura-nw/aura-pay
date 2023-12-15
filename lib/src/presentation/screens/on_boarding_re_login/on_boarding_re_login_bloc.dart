import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'on_boarding_re_login_event.dart';
import 'on_boarding_re_login_state.dart';

final class OnBoardingReLoginBloc
    extends Bloc<OnBoardingReLoginEvent, OnBoardingReLoginState> {
  final AppSecureUseCase _appSecureUseCase_;
  final AuraAccountUseCase _accountUseCase;

  OnBoardingReLoginBloc(
    this._appSecureUseCase_,
    this._accountUseCase,
  ) : super(
          const OnBoardingReLoginState(),
        ) {
    on(_userInputPassword);
    on(_unLockInputPassword);
  }

  void _userInputPassword(
    OnBoardingReLoginEventOnInputPassword event,
    Emitter<OnBoardingReLoginState> emit,
  ) async {
    try {
      final String? password = await _appSecureUseCase_.getCurrentPassword(
        key: AppLocalConstant.passCodeKey,
      );

      if (password == event.password) {
        final accounts = await _accountUseCase.getAccounts();
        emit(
          state.copyWith(
            status: accounts.isEmpty
                ? OnBoardingReLoginStatus.nonHasAccounts
                : OnBoardingReLoginStatus.hasAccounts,
          ),
        );
      } else {
        if (state.wrongCountDown == 0) {
          emit(
            state.copyWith(
              status: OnBoardingReLoginStatus.lockTime,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: OnBoardingReLoginStatus.wrongPassword,
              wrongCountDown: state.wrongCountDown - 1,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingReLoginStatus.wrongPassword,
        ),
      );
    }
  }

  void _unLockInputPassword(
    OnBoardingReLoginEventOnUnLockInputPassword event,
    Emitter<OnBoardingReLoginState> emit,
  ) {
    emit(
      state.copyWith(
        wrongCountDown: 10,
        status: OnBoardingReLoginStatus.none,
      ),
    );
  }
}
