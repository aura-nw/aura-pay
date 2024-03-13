import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_create_eoa_by_google_state.freezed.dart';

enum OnBoardingCreateEOAByGoogleStatus {
  none,
  logged,
  error,
}

@freezed
class OnBoardingCreateEOAByGoogleState with _$OnBoardingCreateEOAByGoogleState {
  const factory OnBoardingCreateEOAByGoogleState({
    @Default(OnBoardingCreateEOAByGoogleStatus.none)
    OnBoardingCreateEOAByGoogleStatus status,
    String ?error,
  }) = _OnBoardingCreateEOAByGoogleState;
}
