import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_re_login_event.freezed.dart';

@freezed
class OnBoardingReLoginEvent with _$OnBoardingReLoginEvent{

  const factory OnBoardingReLoginEvent.userInputPassword(String password) = OnBoardingReLoginEventOnInputPassword;
  const factory OnBoardingReLoginEvent.unLockInput() = OnBoardingReLoginEventOnUnLockInputPassword;
}