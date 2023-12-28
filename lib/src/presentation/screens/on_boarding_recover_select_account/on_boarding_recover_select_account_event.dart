import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_recover_select_account_event.freezed.dart';

@freezed
class OnBoardingRecoverSelectAccountEvent
    with _$OnBoardingRecoverSelectAccountEvent {
  const factory OnBoardingRecoverSelectAccountEvent.fetchAccounts() =
      OnBoardingRecoverSelectAccountEventFetchAccount;

  const factory OnBoardingRecoverSelectAccountEvent.selectAccount({
    required PyxisRecoveryAccount account,
  }) = OnBoardingRecoverSelectAccountEventSelectAccount;
}
