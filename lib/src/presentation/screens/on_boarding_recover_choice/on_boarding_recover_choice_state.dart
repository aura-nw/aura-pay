import 'package:freezed_annotation/freezed_annotation.dart';

enum OnBoardingRecoverChoiceStatus {
  none,
  onLogin,
  loginSuccess,
  loginFailure,
}

@freezed
class OnBoardingRecoverChoiceState {
  const OnBoardingRecoverChoiceState({
    @Default(OnBoardingRecoverChoiceStatus.none)
    required OnBoardingRecoverChoiceStatus status,
  });
}
