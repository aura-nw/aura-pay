import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_pick_account_event.freezed.dart';

@freezed
class OnBoardingPickAccountEvent with _$OnBoardingPickAccountEvent {
  const factory OnBoardingPickAccountEvent.onCreate() =
      OnBoardingPickAccountOnSubmitEvent;

  const factory OnBoardingPickAccountEvent.onChangeAccount({
    required String accountName,
  }) = OnBoardingPickAccountOnPickAccountChangeEvent;
}
