import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';

part 'on_boarding_pick_account_state.freezed.dart';

enum OnBoardingPickAccountStatus {
  init,
  onLoading,
  onActiveSmartAccount,
  onActiveSmartAccountSuccess,
  onGrantFeeError,
  onCheckAddressError,
}

@freezed
class OnBoardingPickAccountState with _$OnBoardingPickAccountState {
  const factory OnBoardingPickAccountState({
    @Default(OnBoardingPickAccountStatus.init)
    OnBoardingPickAccountStatus status,
    @Default(false) bool isReadySubmit,
    @Default(PyxisAccountConstant.defaultName) String accountName,
    String? errorMessage,
    String? smartAccountAddress,
    Uint8List? userPrivateKey,
    Uint8List? saltBytes,
  }) = _OnBoardingPickAccountState;
}
