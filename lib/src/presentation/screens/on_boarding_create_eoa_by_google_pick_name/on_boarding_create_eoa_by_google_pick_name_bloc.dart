import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_create_eoa_by_google_pick_name_event.dart';
import 'on_boarding_create_eoa_by_google_pick_name_state.dart';

class OnBoardingCreateEOAByGooglePickNameBloc extends Bloc<
    OnBoardingCreateEOAByGooglePickNameEvent,
    OnBoardingCreateEOAByGooglePickNameState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final Web3AuthUseCase _web3authUseCase;
  final WalletUseCase _walletUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  OnBoardingCreateEOAByGooglePickNameBloc(
    this._auraAccountUseCase,
    this._controllerKeyUseCase,
    this._web3authUseCase,
    this._walletUseCase,
  ) : super(
          const OnBoardingCreateEOAByGooglePickNameState(),
        ) {
    on(_onChangeWalletName);
    on(_onConfirm);
  }

  void _onChangeWalletName(
    OnBoardingCreateEOAByGooglePickNameOnChangeWalletNameEvent event,
    Emitter<OnBoardingCreateEOAByGooglePickNameState> emit,
  ) {
    emit(
      state.copyWith(
          status: OnBoardingCreateEOAByGooglePickNameStatus.none,
          walletName: event.walletName,
          isReadyConfirm: event.walletName.isNotEmpty),
    );
  }

  void _onConfirm(
    OnBoardingCreateEOAByGooglePickNameOnConfirmEvent event,
    Emitter<OnBoardingCreateEOAByGooglePickNameState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OnBoardingCreateEOAByGooglePickNameStatus.creating,
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
          status: OnBoardingCreateEOAByGooglePickNameStatus.created,
        ),
      );
    } catch (e) {
      LogProvider.log('Create account error ${e.toString()}');
      emit(
        state.copyWith(
          error: e.toString(),
          status: OnBoardingCreateEOAByGooglePickNameStatus.error,
        ),
      );
    }
  }
}
