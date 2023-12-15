import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_recover_choice_state.freezed.dart';

enum OnBoardingRecoverChoiceStatus {
  none,
  onLogin,
  loginSuccess,
  loginFailure,
}

@freezed
class OnBoardingRecoverChoiceState with _$OnBoardingRecoverChoiceState{
  const factory OnBoardingRecoverChoiceState({
    @Default(OnBoardingRecoverChoiceStatus.none)
    OnBoardingRecoverChoiceStatus status,
    String ?errorMessage,
    GoogleAccount ?googleAccount,
  }) = _OnBoardingRecoverChoiceState;
}
