import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';

part 'on_boarding_create_eoa_by_google_pick_name_state.freezed.dart';

enum OnBoardingCreateEOAByGooglePickNameStatus {
  none,
  creating,
  created,
  error,
}

@freezed
class OnBoardingCreateEOAByGooglePickNameState
    with _$OnBoardingCreateEOAByGooglePickNameState {
  const factory OnBoardingCreateEOAByGooglePickNameState({
    @Default(OnBoardingCreateEOAByGooglePickNameStatus.none)
    OnBoardingCreateEOAByGooglePickNameStatus status,
    @Default(true) bool isReadyConfirm,
    @Default(PyxisAccountConstant.defaultNormalWalletName) String walletName,
    String ?error,
  }) = _OnBoardingCreateEOAByGooglePickNameState;
}
