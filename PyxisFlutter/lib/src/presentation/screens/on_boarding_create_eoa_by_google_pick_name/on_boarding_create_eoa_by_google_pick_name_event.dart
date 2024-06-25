import 'package:freezed_annotation/freezed_annotation.dart';
part 'on_boarding_create_eoa_by_google_pick_name_event.freezed.dart';

@freezed
class OnBoardingCreateEOAByGooglePickNameEvent
    with _$OnBoardingCreateEOAByGooglePickNameEvent {
  const factory OnBoardingCreateEOAByGooglePickNameEvent.onChangeWalletName(
    String walletName,
  ) = OnBoardingCreateEOAByGooglePickNameOnChangeWalletNameEvent;

  const factory OnBoardingCreateEOAByGooglePickNameEvent.onConfirm(
  ) = OnBoardingCreateEOAByGooglePickNameOnConfirmEvent;
}
