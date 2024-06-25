import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signed_in_confirm_recover_phrase_event.dart';
import 'signed_in_confirm_recover_phrase_state.dart';

class SignedInConfirmRecoverPhraseBloc extends Bloc<
    SignedInConfirmRecoverPhraseEvent, SignedInConfirmRecoverPhraseState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  SignedInConfirmRecoverPhraseBloc(
    this._auraAccountUseCase,
    this._controllerKeyUseCase, {
    required PyxisWallet pyxisWallet,
  }) : super(
          SignedInConfirmRecoverPhraseState(
            pyxisWallet: pyxisWallet,
          ),
        ) {
    on(_onConfirm);
    on(_onChangeWalletName);
    on(_onChangeCorrect);
  }

  void _onChangeCorrect(
    SignedInConfirmRecoverPhraseOnChangeConfirmPhraseEvent event,
    Emitter<SignedInConfirmRecoverPhraseState> emit,
  ) {
    emit(
      state.copyWith(
        status: SignedInConfirmRecoverPhraseStatus.none,
        isCorrectWord: event.isCorrect,
        isReadyConfirm: event.isCorrect && state.walletName.isNotEmpty,
      ),
    );
  }

  void _onChangeWalletName(
    SignedInConfirmRecoverPhraseOnChangeWalletNameEvent event,
    Emitter<SignedInConfirmRecoverPhraseState> emit,
  ) {
    emit(
      state.copyWith(
        walletName: event.walletName,
        isReadyConfirm: state.isCorrectWord && event.walletName.isNotEmpty,
      ),
    );
  }

  void _onConfirm(
    SignedInConfirmRecoverPhraseOnConfirmEvent event,
    Emitter<SignedInConfirmRecoverPhraseState> emit,
  ) async {
    if (!state.isReadyConfirm) return;

    emit(
      state.copyWith(
        status: SignedInConfirmRecoverPhraseStatus.creating,
      ),
    );
    try {
      await _auraAccountUseCase.saveAccount(
        address: state.pyxisWallet.bech32Address,
        accountName: state.walletName,
        type: AuraAccountType.normal,
        createdType: AuraAccountCreateType.normal,
      );

      await _controllerKeyUseCase.saveKey(
        address: state.pyxisWallet.bech32Address,
        key: state.pyxisWallet.mnemonic ?? state.pyxisWallet.privateKey ?? '',
      );

      emit(
        state.copyWith(
          status: SignedInConfirmRecoverPhraseStatus.created,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignedInConfirmRecoverPhraseStatus.error,
          error: e.toString(),
        ),
      );
      LogProvider.log('On create account error ${e.toString()}');
    }
  }
}
