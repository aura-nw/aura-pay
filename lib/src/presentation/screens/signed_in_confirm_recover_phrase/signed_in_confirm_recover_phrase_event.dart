import 'package:freezed_annotation/freezed_annotation.dart';

part 'signed_in_confirm_recover_phrase_event.freezed.dart';

@freezed
class SignedInConfirmRecoverPhraseEvent
    with _$SignedInConfirmRecoverPhraseEvent {
  const factory SignedInConfirmRecoverPhraseEvent.onChangeConfirmPhrase(
    bool isCorrect,
  ) = SignedInConfirmRecoverPhraseOnChangeConfirmPhraseEvent;

  const factory SignedInConfirmRecoverPhraseEvent.onChangeWalletName(
    String walletName,
  ) = SignedInConfirmRecoverPhraseOnChangeWalletNameEvent;

  const factory SignedInConfirmRecoverPhraseEvent.onConfirm() =
      SignedInConfirmRecoverPhraseOnConfirmEvent;
}
