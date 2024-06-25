import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_scan_fee_state.freezed.dart';

enum OnBoardingScanFeeStatus {
  init,
  onCheckBalance,
  onCheckBalanceUnEnough,
  onCheckBalanceError,
  onActiveAccount,
  onActiveAccountSuccess,
  onActiveAccountError,
}

@freezed
class OnBoardingScanFeeState with _$OnBoardingScanFeeState {
  const factory OnBoardingScanFeeState({
    @Default(OnBoardingScanFeeStatus.init) OnBoardingScanFeeStatus status,
    String? errorMessage,
    required String smartAccountAddress,
    required Uint8List privateKey,
    required Uint8List salt,
    required String accountName,
  }) = _OnBoardingScanFeeState;
}
