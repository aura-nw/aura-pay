import 'package:domain/domain.dart' show WalletUseCase;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_pick_account_event.dart';
import 'on_boarding_pick_account_state.dart';

class OnBoardingPickAccountBloc
    extends Bloc<OnBoardingPickAccountEvent, OnBoardingPickAccountState> {
  final WalletUseCase _walletUseCase;

  OnBoardingPickAccountBloc(this._walletUseCase)
      : super(
          const OnBoardingPickAccountState(),
        ) {
    on(_onChangeAccountName);
    on(_onCreate);
  }

  void _onCreate(
    OnBoardingPickAccountOnSubmitEvent event,
    Emitter<OnBoardingPickAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OnBoardingPickAccountStatus.onLoading,
      ),
    );

    try {
      final wallet = await _walletUseCase.createWallet(
        walletName: state.accountName,
      );

      /// call api check fee gas

      await Future.delayed(const Duration(
         milliseconds: 1200,
      ));

      bool isFreeFee = false;

      if(isFreeFee){
        emit(state.copyWith(
          status: OnBoardingPickAccountStatus.onCheckAddressEnoughFee,
        ));

      }else{
        emit(state.copyWith(
          status: OnBoardingPickAccountStatus.onCheckAddressUnEnoughFee,
          walletAddress: wallet.bech32Address,
        ));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingPickAccountStatus.onCheckAddressError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onChangeAccountName(
    OnBoardingPickAccountOnPickAccountChangeEvent event,
    Emitter<OnBoardingPickAccountState> emit,
  ) {
    emit(
      state.copyWith(
        accountName: event.accountName,
        isReadySubmit: event.accountName.isNotEmpty,
      ),
    );
  }
}
