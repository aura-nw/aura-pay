import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_create_new_sm_account_scan_fee_state.freezed.dart';

enum SignedInCreateNewSmAccountScanFeeStatus {
  init,
  onCheckBalance,
  onCheckBalanceUnEnough,
  onCheckBalanceError,
  onActiveAccount,
  onActiveAccountSuccess,
  onActiveAccountError,
}

@freezed
class SignedInCreateNewSmAccountScanFeeState with _$SignedInCreateNewSmAccountScanFeeState {
  const factory SignedInCreateNewSmAccountScanFeeState({
    @Default(SignedInCreateNewSmAccountScanFeeStatus.init) SignedInCreateNewSmAccountScanFeeStatus status,
    String? errorMessage,
    required String smartAccountAddress,
    required Uint8List privateKey,
    required Uint8List salt,
    required String accountName,
  }) = _SignedInCreateNewSmAccountScanFeeState;
}
