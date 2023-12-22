import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/crypto_helper.dart';
import 'on_boarding_setup_passcode_state.dart';

class OnBoardingSetupPasscodeBloc extends Cubit<OnBoardingSetupPasscodeState> {
  final AppSecureUseCase _appSecureUseCase;

  OnBoardingSetupPasscodeBloc(this._appSecureUseCase)
      : super(
          const OnBoardingSetupPasscodeState(
            status: OnBoardingSetupPasscodeStatus.init,
          ),
        );

  Future<void> onSavePassCode(String passCode) async {
    emit(
      state.copyWith(
        status: OnBoardingSetupPasscodeStatus.onSavePasscode,
      ),
    );

    try {
      String hashPassCode = CryptoHelper.hashStringBySha256(passCode);

      await _appSecureUseCase.savePassword(
        key: AppLocalConstant.passCodeKey,
        password: hashPassCode,
      );
    } catch (e) {
      //
    } finally {
      emit(
        state.copyWith(
          status: OnBoardingSetupPasscodeStatus.savePasscodeDone,
        ),
      );
    }
  }
}
