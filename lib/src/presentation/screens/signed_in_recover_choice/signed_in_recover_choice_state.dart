import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_recover_choice_state.freezed.dart';

enum SignedInRecoverChoiceStatus {
  none,
  onLogin,
  loginSuccess,
  loginFailure,
}

@freezed
class SignedInRecoverChoiceState with _$SignedInRecoverChoiceState{
  const factory SignedInRecoverChoiceState({
    @Default(SignedInRecoverChoiceStatus.none)
    SignedInRecoverChoiceStatus status,
    String ?errorMessage,
    String ?accessToken,
  }) = _SignedInRecoverChoiceState;
}
