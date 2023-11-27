import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_pick_account_state.freezed.dart';

enum OnBoardingPickAccountStatus {
  init,
  onLoading,
  onCheckAddressEnoughFee,
  onCheckAddressUnEnoughFee,
  onCheckAddressError,
}

@freezed
class OnBoardingPickAccountState with _$OnBoardingPickAccountState {
  const factory OnBoardingPickAccountState({
    @Default(OnBoardingPickAccountStatus.init)
    OnBoardingPickAccountStatus status,
    @Default(false) bool isReadySubmit,
    @Default('') String accountName,
    String? errorMessage,
    String? smartAccountAddress,
    Uint8List? userPrivateKey,
    Uint8List? saltBytes,
  }) = _OnBoardingPickAccountState;
}
