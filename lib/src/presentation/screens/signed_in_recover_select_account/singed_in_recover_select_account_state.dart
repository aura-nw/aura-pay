import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'singed_in_recover_select_account_state.freezed.dart';

enum SingedInRecoverSelectAccountStatus {
  loading,
  loaded,
  error,
}

@freezed
class SingedInRecoverSelectAccountState
    with _$SingedInRecoverSelectAccountState {
  const factory SingedInRecoverSelectAccountState({
    @Default(SingedInRecoverSelectAccountStatus.loading)
    SingedInRecoverSelectAccountStatus status,
    String ?error,
    @Default([]) List<PyxisRecoveryAccount> accounts,
    PyxisRecoveryAccount ?selectedAccount,
    required GoogleAccount googleAccount,
  }) = _SingedInRecoverSelectAccountState;
}
