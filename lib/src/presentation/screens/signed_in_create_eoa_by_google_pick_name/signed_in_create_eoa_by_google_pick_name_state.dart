import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';

part 'signed_in_create_eoa_by_google_pick_name_state.freezed.dart';

enum SignedInCreateEOAByGooglePickNameStatus {
  none,
  creating,
  created,
  error,
}

@freezed
class SignedInCreateEOAByGooglePickNameState
    with _$SignedInCreateEOAByGooglePickNameState {
  const factory SignedInCreateEOAByGooglePickNameState({
    @Default(SignedInCreateEOAByGooglePickNameStatus.none)
    SignedInCreateEOAByGooglePickNameStatus status,
    @Default(true) bool isReadyConfirm,
    @Default(PyxisAccountConstant.defaultNormalWalletName) String walletName,
    String ?error,
  }) = _SignedInCreateEOAByGooglePickNameState;
}
