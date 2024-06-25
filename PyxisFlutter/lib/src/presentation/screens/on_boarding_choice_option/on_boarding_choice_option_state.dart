import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_choice_option_state.freezed.dart';

enum OnBoardingChoiceOptionStatus {
  none,
  onLogin,
  loginSuccess,
  loginFailure,
}

@freezed
class OnBoardingChoiceOptionState with _$OnBoardingChoiceOptionState {
  const factory OnBoardingChoiceOptionState({
    @Default(OnBoardingChoiceOptionStatus.none)
    OnBoardingChoiceOptionStatus status,
    String? errorMessage,
    GoogleAccount? googleAccount,
  }) = _OnBoardingChoiceOptionState;
}
