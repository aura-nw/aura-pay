import 'package:freezed_annotation/freezed_annotation.dart';
part 'signed_in_recover_choice_event.freezed.dart';

@freezed
class SignedInRecoverChoiceEvent with _$SignedInRecoverChoiceEvent{
  const factory SignedInRecoverChoiceEvent.onUsingGoogleLogin() = SignedInRecoverChoiceEventOnGoogleSignIn;
}