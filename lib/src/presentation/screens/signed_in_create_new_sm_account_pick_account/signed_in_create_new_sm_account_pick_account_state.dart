import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_create_new_sm_account_pick_account_state.freezed.dart';

enum SignedInCreateNewPickAccountStatus {
  init,
  onLoading,
  onCheckAddressEnoughFee,
  onCheckAddressUnEnoughFee,
  onCheckAddressError,
}

@freezed
class SignedInCreateNewSmAccountPickAccountState with _$SignedInCreateNewSmAccountPickAccountState {
  const factory SignedInCreateNewSmAccountPickAccountState({
    @Default(SignedInCreateNewPickAccountStatus.init)
    SignedInCreateNewPickAccountStatus status,
    @Default(false) bool isReadySubmit,
    @Default('') String accountName,
    String? errorMessage,
    String? smartAccountAddress,
    Uint8List? userPrivateKey,
    Uint8List? saltBytes,
  }) = _SignedInCreateNewSmAccountPickAccountState;
}
