import 'dart:async';
import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/helpers/local_auth_helper.dart';
import 'package:pyxis_mobile/src/core/pyxis_wallet_core/pyxis_wallet_helper.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AppSecureUseCase _appSecureUseCase;
  final AuraAccountUseCase _accountUseCase;
  final AuthUseCase _authUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  SplashScreenCubit(
    this._appSecureUseCase,
    this._accountUseCase,
    this._authUseCase,
    this._deviceManagementUseCase,
    this._controllerKeyUseCase,
  ) : super(
          const SplashScreenState(),
        );

  Future<void> starting() async {
    emit(state.copyWith(
      status: SplashScreenStatus.starting,
    ));

    try {
      // Default status
      SplashScreenStatus status = SplashScreenStatus.notHasPassCodeOrError;

      final bool hasPassCode = await _appSecureUseCase.hasPassCode(
        key: AppLocalConstant.passCodeKey,
      );

      if (hasPassCode) {
        // if user set biometric. Check authentication by biometric. If user does not allow

        // user has passcode
        status = SplashScreenStatus.hasPassCode;

        // check user set biometric
        final bool isReadySetAuthenticationByBiometric =
            await _appSecureUseCase.alReadySetBioMetric(
          key: AppLocalConstant.bioMetricKey,
        );

        // user has set biometric
        if (isReadySetAuthenticationByBiometric) {
          // check device can use bio
          final bool isSupportBio =
              await LocalAuthHelper.canAuthenticateWithBiometrics();

          // this device support biometric
          if (isSupportBio) {
            bool isVerify = await LocalAuthHelper.requestLocalAuth();

            final account = await _accountUseCase.getFirstAccount();

            // users verify successful
            if (isVerify && account != null) {
              status = SplashScreenStatus.verifyByBioSuccessful;

              final String? privateKey =
                  await _controllerKeyUseCase.getKey(address: account.address);

              if (privateKey != null) {
                unawaited(
                  _refreshToken(
                    privateKey:
                        PyxisWalletHelper.getPrivateKeyFromString(privateKey),
                    address: account.address,
                  ),
                );
              }
            }
          }
        }
      }

      emit(
        state.copyWith(status: status),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SplashScreenStatus.notHasPassCodeOrError,
      ));
    }
  }

  Future<void> _refreshToken({
    required String address,
    required Uint8List privateKey,
  }) async {
    try {
      // Sign in to refresh access token.
      // await AuthHelper.signIn(
      //   authUseCase: _authUseCase,
      //   privateKey: privateKey,
      //   walletAddress: address,
      //   deviceManagementUseCase: _deviceManagementUseCase,
      // );
    } catch (e) {
      // Don't handle exception
      LogProvider.log(
        e.toString(),
      );
    }
  }
}
