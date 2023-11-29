import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'on_boarding_import_key_event.dart';
import 'on_boarding_import_key_state.dart';

class OnBoardingImportKeyBloc
    extends Bloc<OnBoardingImportKeyEvent, OnBoardingImportKeyState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;

  OnBoardingImportKeyBloc(this._walletUseCase,this._smartAccountUseCase)
      : super(
          const OnBoardingImportKeyState(),
        ) {
    on(_onSelectAccountType);
    on(_onSelectImportType);
    on(_onInputKey);
    on(_onImport);
  }

  void _onSelectAccountType(
    OnBoardingImportKeyOnSelectAccountTypeEvent event,
    Emitter<OnBoardingImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        pyxisWalletType: event.accountType,
        key: '',
        isReadySubmit: false,
      ),
    );
  }

  void _onSelectImportType(
    OnBoardingImportKeyOnSelectImportTypeEvent event,
    Emitter<OnBoardingImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        importWalletType: event.importType,
        key: '',
        isReadySubmit: false,
      ),
    );
  }

  void _onInputKey(
    OnBoardingImportKeyOnInputKeyEvent event,
    Emitter<OnBoardingImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        key: event.key,
        isReadySubmit: event.key.isNotEmpty,
      ),
    );
  }

  void _onImport(
    OnBoardingImportKeyOnSubmitEvent event,
    Emitter<OnBoardingImportKeyState> emit,
  ) async {

    if(state.pyxisWalletType == PyxisWalletType.smartAccount) return;

    emit(
      state.copyWith(
        status: OnBoardingImportKeyStatus.onLoading,
      ),
    );
    try {
      switch(state.pyxisWalletType){
        case PyxisWalletType.smartAccount:

          break;
        case PyxisWalletType.normalWallet:
          final wallet = await _walletUseCase.importWallet(
            privateKeyOrPassPhrase: state.key,
            /// Set Default account name
            walletName: 'Account 1',
          );
          emit(
            state.copyWith(
              status: OnBoardingImportKeyStatus.onImportAccountSuccess,
              walletAddress: wallet.bech32Address
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: OnBoardingImportKeyStatus.onImportAccountError,
        ),
      );
    }
  }
}
