import 'package:freezed_annotation/freezed_annotation.dart';
part 'signed_in_create_eoa_by_google_pick_name_event.freezed.dart';

@freezed
class SignedInCreateEOAByGooglePickNameEvent
    with _$SignedInCreateEOAByGooglePickNameEvent {
  const factory SignedInCreateEOAByGooglePickNameEvent.onChangeWalletName(
    String walletName,
  ) = SignedInCreateEOAByGooglePickNameOnChangeWalletNameEvent;

  const factory SignedInCreateEOAByGooglePickNameEvent.onConfirm(
  ) = SignedInCreateEOAByGooglePickNameOnConfirmEvent;

  const factory SignedInCreateEOAByGooglePickNameEvent.onInit(
  ) = SignedInCreateEOAByGooglePickNameOnInitEvent;
}
