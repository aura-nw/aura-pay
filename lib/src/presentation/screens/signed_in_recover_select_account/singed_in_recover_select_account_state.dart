import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'singed_in_recover_select_account_state.freezed.dart';

enum SingedInRecoverSelectAccountStatus {
  loading,
  loaded,
  error,
  existsAccount,
}

@freezed
class SingedInRecoverSelectAccountState
    with _$SingedInRecoverSelectAccountState {
  const factory SingedInRecoverSelectAccountState({
    @Default(SingedInRecoverSelectAccountStatus.loading)
    SingedInRecoverSelectAccountStatus status,
    String ?error,
    @Default([]) List<PyxisRecoveryAccount> accounts,
    @Default([]) List<AuraAccount> auraAccounts,
    PyxisRecoveryAccount ?selectedAccount,
    required GoogleAccount googleAccount,
    @Default(false) bool preSelectStatus,
  }) = _SingedInRecoverSelectAccountState;
}
