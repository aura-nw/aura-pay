import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';

part 'signed_in_pick_account_state.freezed.dart';

enum SignedInPickAccountStatus {
  init,
  onLoading,
  onActiveSmartAccount,
  onActiveSmartAccountSuccess,
  onGrantFeeError,
  onCheckAddressError,
}

@freezed
class SignedInPickAccountState with _$SignedInPickAccountState {
  const factory SignedInPickAccountState({
    @Default(SignedInPickAccountStatus.init)
    SignedInPickAccountStatus status,
    @Default(false) bool isReadySubmit,
    @Default(PyxisAccountConstant.defaultName) String accountName,
    String? errorMessage,
    String? smartAccountAddress,
    Uint8List? userPrivateKey,
    Uint8List? saltBytes,
  }) = _SignedInPickAccountState;
}
