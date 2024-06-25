import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_confirm_recover_phrase_event.dart';
import 'on_boarding_confirm_recover_phrase_state.dart';

class OnBoardingConfirmRecoverPhraseBloc extends Bloc<
    OnBoardingConfirmRecoverPhraseEvent, OnBoardingConfirmRecoverPhraseState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  OnBoardingConfirmRecoverPhraseBloc(
    this._auraAccountUseCase,
    this._controllerKeyUseCase, {
    required PyxisWallet pyxisWallet,
  }) : super(
          OnBoardingConfirmRecoverPhraseState(
            pyxisWallet: pyxisWallet,
          ),
        ) {
    on(_onConfirm);
    on(_onChangeWalletName);
    on(_onChangeCorrect);
  }

  void _onChangeCorrect(
    OnBoardingConfirmRecoverPhraseOnChangeConfirmPhraseEvent event,
    Emitter<OnBoardingConfirmRecoverPhraseState> emit,
  ) {
    emit(
      state.copyWith(
        status: OnBoardingConfirmRecoverPhraseStatus.none,
        isCorrectWord: event.isCorrect,
        isReadyConfirm: event.isCorrect && state.walletName.isNotEmpty,
      ),
    );
  }

  void _onChangeWalletName(
    OnBoardingConfirmRecoverPhraseOnChangeWalletNameEvent event,
    Emitter<OnBoardingConfirmRecoverPhraseState> emit,
  ) {
    emit(
      state.copyWith(
        walletName: event.walletName,
        isReadyConfirm: state.isCorrectWord && event.walletName.isNotEmpty,
      ),
    );
  }

  void _onConfirm(
    OnBoardingConfirmRecoverPhraseOnConfirmEvent event,
    Emitter<OnBoardingConfirmRecoverPhraseState> emit,
  ) async {
    if (!state.isReadyConfirm) return;

    emit(
      state.copyWith(
        status: OnBoardingConfirmRecoverPhraseStatus.creating,
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
          status: OnBoardingConfirmRecoverPhraseStatus.created,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingConfirmRecoverPhraseStatus.error,
          error: e.toString(),
        ),
      );
      LogProvider.log('On create account error ${e.toString()}');
    }
  }
}
