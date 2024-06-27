import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';

part 'on_boarding_confirm_recover_phrase_state.freezed.dart';

enum OnBoardingConfirmRecoverPhraseStatus {
  none,
  creating,
  created,
  error,
}

@freezed
class OnBoardingConfirmRecoverPhraseState
    with _$OnBoardingConfirmRecoverPhraseState {
  const factory OnBoardingConfirmRecoverPhraseState({
    @Default(OnBoardingConfirmRecoverPhraseStatus.none)
    OnBoardingConfirmRecoverPhraseStatus status,
    required PyxisWallet pyxisWallet,
    @Default(false) bool isReadyConfirm,
    @Default(false) bool isCorrectWord,
    String? error,
    @Default(PyxisAccountConstant.defaultNormalWalletName) String walletName,
  }) = _OnBoardingConfirmRecoverPhraseState;
}
