import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_confirm_recover_phrase_event.freezed.dart';

@freezed
class OnBoardingConfirmRecoverPhraseEvent
    with _$OnBoardingConfirmRecoverPhraseEvent {
  const factory OnBoardingConfirmRecoverPhraseEvent.onChangeConfirmPhrase(
    bool isCorrect,
  ) = OnBoardingConfirmRecoverPhraseOnChangeConfirmPhraseEvent;

  const factory OnBoardingConfirmRecoverPhraseEvent.onChangeWalletName(
    String walletName,
  ) = OnBoardingConfirmRecoverPhraseOnChangeWalletNameEvent;

  const factory OnBoardingConfirmRecoverPhraseEvent.onConfirm() =
      OnBoardingConfirmRecoverPhraseOnConfirmEvent;
}
