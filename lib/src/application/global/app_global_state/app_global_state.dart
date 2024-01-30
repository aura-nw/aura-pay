import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_global_state.freezed.dart';

enum AppGlobalStatus {
  unauthorized,
  authorized,
}

enum OnBoardingStatus{
  none,
  createSmAccountSuccess,
  recoverSmartAccountSuccess,
  importSmartAccountSuccessFul,
}

@freezed
class AppGlobalState with _$AppGlobalState {
  const factory AppGlobalState({
    @Default(AppGlobalStatus.unauthorized) AppGlobalStatus status,
    @Default(OnBoardingStatus.none) OnBoardingStatus onBoardingStatus,
  }) = _AppGlobalState;
}
