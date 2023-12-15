import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_recover_sign_event.freezed.dart';

@freezed
class OnBoardingRecoverSignEvent with _$OnBoardingRecoverSignEvent {
  const factory OnBoardingRecoverSignEvent.onInit() =
      OnBoardingRecoverSignEventOnInit;

  const factory OnBoardingRecoverSignEvent.onChangeFee({
    required String fee,
  }) = OnBoardingRecoverSignEventOnChangeFee;

  const factory OnBoardingRecoverSignEvent.onConfirm() =
      OnBoardingRecoverSignEventOnConfirm;
}
