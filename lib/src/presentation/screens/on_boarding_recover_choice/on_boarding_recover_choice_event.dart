import 'package:freezed_annotation/freezed_annotation.dart';
part 'on_boarding_recover_choice_event.freezed.dart';

@freezed
class OnBoardingRecoverChoiceEvent with _$OnBoardingRecoverChoiceEvent{
  const factory OnBoardingRecoverChoiceEvent.onUsingGoogleLogin() = OnBoardingRecoverChoiceOnGoogleSignInEvent;
}