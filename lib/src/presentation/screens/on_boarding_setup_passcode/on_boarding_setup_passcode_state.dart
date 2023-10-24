import 'package:freezed_annotation/freezed_annotation.dart';

enum OnBoardingSetupPasscodeStatus {
  init,
  createPasscodeSuccess,
  confirmPasscodeSuccess,
  confirmPasscodeWrong,
}

@freezed
class OnBoardingSetupPasscodeState {
  const OnBoardingSetupPasscodeState({
    @Default(OnBoardingSetupPasscodeStatus.init)
    required OnBoardingSetupPasscodeStatus status,
  });
}
