import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'singed_in_recover_select_account_event.freezed.dart';

@freezed
class SingedInRecoverSelectAccountEvent
    with _$SingedInRecoverSelectAccountEvent {
  const factory SingedInRecoverSelectAccountEvent.fetchAccounts() =
      SingedInRecoverSelectAccountEventFetchAccount;

  const factory SingedInRecoverSelectAccountEvent.selectAccount({
    required AuraAccount account,
  }) = SingedInRecoverSelectAccountEventSelectAccount;
}
