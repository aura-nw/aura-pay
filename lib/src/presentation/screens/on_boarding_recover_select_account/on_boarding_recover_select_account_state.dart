import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_recover_select_account_state.freezed.dart';

enum OnboardingRecoverSelectAccountStatus {
  loading,
  loaded,
  error,
}

@freezed
class OnboardingRecoverSelectAccountState
    with _$OnboardingRecoverSelectAccountState {
  const factory OnboardingRecoverSelectAccountState({
    @Default(OnboardingRecoverSelectAccountStatus.loading)
    OnboardingRecoverSelectAccountStatus status,
    String ?error,
    @Default([]) List<AuraAccount> accounts,
    AuraAccount ?selectedAccount,
    required GoogleAccount googleAccount,
  }) = _OnboardingRecoverSelectAccountState;
}
