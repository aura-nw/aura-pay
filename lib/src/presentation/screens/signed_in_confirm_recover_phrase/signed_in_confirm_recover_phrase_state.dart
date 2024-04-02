import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';

part 'signed_in_confirm_recover_phrase_state.freezed.dart';

enum SignedInConfirmRecoverPhraseStatus {
  none,
  creating,
  created,
  error,
}

@freezed
class SignedInConfirmRecoverPhraseState
    with _$SignedInConfirmRecoverPhraseState {
  const factory SignedInConfirmRecoverPhraseState({
    @Default(SignedInConfirmRecoverPhraseStatus.none)
    SignedInConfirmRecoverPhraseStatus status,
    required PyxisWallet pyxisWallet,
    @Default(false) bool isReadyConfirm,
    @Default(false) bool isCorrectWord,
    String? error,
    @Default(PyxisAccountConstant.defaultNormalWalletName) String walletName,
  }) = _SignedInConfirmRecoverPhraseState;
}
