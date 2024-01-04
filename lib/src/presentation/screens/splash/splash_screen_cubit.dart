import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wallet_connect_service.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/local_auth_helper.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AppSecureUseCase _appSecureUseCase;
  final AuraAccountUseCase _accountUseCase;

  SplashScreenCubit(this._appSecureUseCase, this._accountUseCase)
      : super(
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

    try {
      WalletConnectService web3walletService = WalletConnectService();
      await web3walletService.create();
      await web3walletService.init();
      GetIt.I.registerSingleton<WalletConnectService>(web3walletService);
    } catch (e) {
      print('WalletConnectProviderImpl init error: $e');
    }
  }
}
