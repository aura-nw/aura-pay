import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'signed_in_recover_sign_state.freezed.dart';

enum SignedInRecoverSignStatus {
  none,
  onRecovering,
  onRecoverSuccess,
  onRecoverFail,
}

@freezed
class SignedInRecoverSignState with _$SignedInRecoverSignState {
  const factory SignedInRecoverSignState({
    required GoogleAccount googleAccount,
    required PyxisRecoveryAccount account,
    @Default(SignedInRecoverSignStatus.none)
    SignedInRecoverSignStatus status,
    String ?error,
    @Default('') String transactionFee,
    @Default('') String highTransactionFee,
    @Default('') String lowTransactionFee,
    @Default(false) bool isShowFullMsg,
    MsgRecover ?msgRecover,
    String ?memo,
  }) = _SignedInRecoverSignState;
}