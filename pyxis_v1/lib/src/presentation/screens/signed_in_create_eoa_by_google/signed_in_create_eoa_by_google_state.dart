import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_create_eoa_by_google_state.freezed.dart';

enum SignedInCreateEOAByGoogleStatus {
  none,
  logged,
  error,
}

@freezed
class SignedInCreateEOAByGoogleState with _$SignedInCreateEOAByGoogleState {
  const factory SignedInCreateEOAByGoogleState({
    @Default(SignedInCreateEOAByGoogleStatus.none)
    SignedInCreateEOAByGoogleStatus status,
    String ?error,
  }) = _SignedInCreateEOAByGoogleState;
}
