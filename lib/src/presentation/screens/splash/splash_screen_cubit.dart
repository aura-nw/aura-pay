import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/local_auth_helper.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AppSecureUseCase _appSecureUseCase;

  SplashScreenCubit(this._appSecureUseCase)
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
        status =  SplashScreenStatus.hasPassCode;


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
            bool isVerify  = await LocalAuthHelper.requestLocalAuth();

            // users verify successful
            if(isVerify){
              status = SplashScreenStatus.verifyByBioSuccessful;
            }
          }
        }
      }

      emit(
        state.copyWith(
          status: status
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SplashScreenStatus.notHasPassCodeOrError,
      ));
    }
  }
}
