import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class OnBoardingRecoverChoiceEvent {
  const OnBoardingRecoverChoiceEvent();

  factory OnBoardingRecoverChoiceEvent.onUsingGoogleLogin(){
    return const OnBoardingRecoverChoiceEvent();
  }
}