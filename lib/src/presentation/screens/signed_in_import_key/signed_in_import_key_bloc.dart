import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

import 'signed_in_import_key_state.dart';
import 'singed_in_import_key_event.dart';

class SignedInImportKeyBloc
    extends Bloc<SignedInImportKeyEvent, SignedInImportKeyState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;

  SignedInImportKeyBloc(this._walletUseCase,this._smartAccountUseCase)
      : super(
          const SignedInImportKeyState(),
        ) {
    on(_onSelectAccountType);
    on(_onSelectImportType);
    on(_onInputKey);
    on(_onImport);
  }

  void _onSelectAccountType(
    SignedInImportKeyOnSelectAccountTypeEvent event,
    Emitter<SignedInImportKeyState> emit,
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
    SignedInImportKeyOnSelectImportTypeEvent event,
    Emitter<SignedInImportKeyState> emit,
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
    SignedInImportKeyOnInputKeyEvent event,
    Emitter<SignedInImportKeyState> emit,
  ) {
    emit(
      state.copyWith(
        key: event.key,
        isReadySubmit: event.key.isNotEmpty,
      ),
    );
  }

  void _onImport(
    SignedInImportKeyOnSubmitEvent event,
    Emitter<SignedInImportKeyState> emit,
  ) async {

    if(state.pyxisWalletType == PyxisWalletType.smartAccount) return;

    emit(
      state.copyWith(
        status: SignedInImportKeyStatus.onLoading,
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
              status: SignedInImportKeyStatus.onImportAccountSuccess,
              walletAddress: wallet.bech32Address
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: SignedInImportKeyStatus.onImportAccountError,
        ),
      );
    }
  }
}
