import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_create_new_sm_account_pick_account_event.freezed.dart';

@freezed
class SignedInCreateNewSmAccountPickAccountEvent with _$SignedInCreateNewSmAccountPickAccountEvent {
  const factory SignedInCreateNewSmAccountPickAccountEvent.onCreate() =
  SignedInCreateNewPickAccountOnSubmitEvent;

  const factory SignedInCreateNewSmAccountPickAccountEvent.onChangeAccount({
    required String accountName,
  }) = SignedInCreateNewPickAccountChangeEvent;
}
