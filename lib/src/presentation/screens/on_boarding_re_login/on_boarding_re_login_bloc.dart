import 'dart:async';
import 'dart:typed_data';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/helpers/crypto_helper.dart';
import 'on_boarding_re_login_event.dart';
import 'on_boarding_re_login_state.dart';

final class OnBoardingReLoginBloc
    extends Bloc<OnBoardingReLoginEvent, OnBoardingReLoginState> {
  final AppSecureUseCase _appSecureUseCase_;
  final AuraAccountUseCase _accountUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  OnBoardingReLoginBloc(
    this._appSecureUseCase_,
    this._accountUseCase,
    this._authUseCase,
    this._deviceManagementUseCase,
    this._controllerKeyUseCase,
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

      String passCodeCompare = CryptoHelper.hashStringBySha256(event.password);

      if (password == passCodeCompare) {
        final account = await _accountUseCase.getFirstAccount();

        OnBoardingReLoginStatus status = OnBoardingReLoginStatus.nonHasAccounts;

        if (account != null) {
          status = OnBoardingReLoginStatus.hasAccounts;

          final String? privateKey = await _controllerKeyUseCase.getKey(
            address: account.address,
          );

          if (privateKey != null) {
            unawaited(
              _refreshToken(
                address: account.address,
                privateKey: AuraWalletHelper.getPrivateKeyFromString(
                  privateKey,
                ),
              ),
            );
          }
        }

        emit(
          state.copyWith(
            status: status,
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

  Future<void> _refreshToken({
    required String address,
    required Uint8List privateKey,
  }) async {
    try {
      // Sign in to refresh access token.
      // final String accessToken = await AuthHelper.signIn(
      //   authUseCase: _authUseCase,
      //   privateKey: privateKey,
      //   walletAddress: address,
      //   deviceManagementUseCase: _deviceManagementUseCase,
      // );
      //
      // await AuthHelper.saveTokenByWalletAddress(
      //   authUseCase: _authUseCase,
      //   walletAddress: address,
      //   accessToken: accessToken,
      // );
    } catch (e) {
      // Don't handle exception
      LogProvider.log(
        e.toString(),
      );
    }
  }
}
