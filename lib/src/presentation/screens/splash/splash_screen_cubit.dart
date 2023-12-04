import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
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
      final bool hasPassCode = await _appSecureUseCase.hasPassCode(
        key: AppLocalConstant.passCodeKey,
      );

      emit(
        state.copyWith(
          status: hasPassCode
              ? SplashScreenStatus.hasPassCode
              : SplashScreenStatus.notHasPassCodeOrError,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SplashScreenStatus.notHasPassCodeOrError,
      ));
    }
  }
}
