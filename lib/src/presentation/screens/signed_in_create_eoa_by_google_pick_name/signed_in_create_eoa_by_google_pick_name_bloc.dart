import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signed_in_create_eoa_by_google_pick_name_event.dart';
import 'signed_in_create_eoa_by_google_pick_name_state.dart';

class SignedInCreateEOAByGooglePickNameBloc extends Bloc<
    SignedInCreateEOAByGooglePickNameEvent,
    SignedInCreateEOAByGooglePickNameState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final Web3AuthUseCase _web3authUseCase;
  final WalletUseCase _walletUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  SignedInCreateEOAByGooglePickNameBloc(
    this._auraAccountUseCase,
    this._controllerKeyUseCase,
    this._web3authUseCase,
    this._walletUseCase,
  ) : super(
          const SignedInCreateEOAByGooglePickNameState(),
        ) {
    on(_onChangeWalletName);
    on(_onConfirm);
  }

  void _onChangeWalletName(
    SignedInCreateEOAByGooglePickNameOnChangeWalletNameEvent event,
    Emitter<SignedInCreateEOAByGooglePickNameState> emit,
  ) {
    emit(
      state.copyWith(
          status: SignedInCreateEOAByGooglePickNameStatus.none,
          walletName: event.walletName,
          isReadyConfirm: event.walletName.isNotEmpty),
    );
  }

  void _onConfirm(
    SignedInCreateEOAByGooglePickNameOnConfirmEvent event,
    Emitter<SignedInCreateEOAByGooglePickNameState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SignedInCreateEOAByGooglePickNameStatus.creating,
      ),
    );
    try {
      final String privateKey = await _web3authUseCase.getPrivateKey();

      final PyxisWallet wallet = await _walletUseCase.importWallet(
        privateKeyOrPassPhrase: privateKey,
      );

      await _auraAccountUseCase.saveAccount(
        address: wallet.bech32Address,
        accountName: state.walletName,
        type: AuraAccountType.normal,
        needBackup: true,
      );

      await _controllerKeyUseCase.saveKey(
        address: wallet.bech32Address,
        key: privateKey,
      );

      await _web3authUseCase.onLogout();

      emit(
        state.copyWith(
          status: SignedInCreateEOAByGooglePickNameStatus.created,
        ),
      );
    } catch (e) {
      LogProvider.log('Create account error ${e.toString()}');
      emit(
        state.copyWith(
          error: e.toString(),
          status: SignedInCreateEOAByGooglePickNameStatus.error,
        ),
      );
    }
  }
}
