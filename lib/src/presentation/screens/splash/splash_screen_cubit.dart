import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(const SplashScreenState());

  Future<void> starting() async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    emit(
      state.copyWith(
        status: SplashScreenStatus.loadWalletNull,
      ),
    );
  }
}
