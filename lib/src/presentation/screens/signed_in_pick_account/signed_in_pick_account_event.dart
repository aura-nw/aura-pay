import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_pick_account_event.freezed.dart';

@freezed
class SignedInPickAccountEvent with _$SignedInPickAccountEvent {
  const factory SignedInPickAccountEvent.onCreate() =
      SignedInPickAccountOnSubmitEvent;

  const factory SignedInPickAccountEvent.onChangeAccount({
    required String accountName,
  }) = SignedInPickAccountOnPickAccountChangeEvent;
}
