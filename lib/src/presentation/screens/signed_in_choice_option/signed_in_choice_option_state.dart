import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_choice_option_state.freezed.dart';

enum SignedInChoiceOptionStatus {
  none,
  onLogin,
  loginSuccess,
  loginFailure,
}

@freezed
class SignedInChoiceOptionState with _$SignedInChoiceOptionState {
  const factory SignedInChoiceOptionState({
    @Default(SignedInChoiceOptionStatus.none)
    SignedInChoiceOptionStatus status,
    String? errorMessage,
    GoogleAccount? googleAccount,
  }) = _SignedInChoiceOptionState;
}
