import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_setup_passcode_state.freezed.dart';

enum OnBoardingSetupPasscodeStatus {
  init,
  createPasscodeSuccess,
  confirmPasscodeSuccess,
  confirmPasscodeWrong,
}

@freezed
class OnBoardingSetupPasscodeState with _$OnBoardingSetupPasscodeState{
  const factory OnBoardingSetupPasscodeState({
    @Default(OnBoardingSetupPasscodeStatus.init)
    OnBoardingSetupPasscodeStatus status,
  }) = _OnBoardingSetupPasscodeState;
}
