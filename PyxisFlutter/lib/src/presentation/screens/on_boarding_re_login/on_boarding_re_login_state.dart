import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_re_login_state.freezed.dart';

enum OnBoardingReLoginStatus {
  none,
  wrongPassword,
  lockTime,
  hasAccounts,
  nonHasAccounts,
}

@freezed
class OnBoardingReLoginState with _$OnBoardingReLoginState {
  const factory OnBoardingReLoginState({
    @Default(OnBoardingReLoginStatus.none) OnBoardingReLoginStatus status,
    @Default(10) int wrongCountDown,
  }) = _OnBoardingReLoginState;
}