import 'dart:typed_data';

import 'package:domain/domain.dart' show WalletUseCase, SmartAccountUseCase;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_pick_account_event.dart';
import 'on_boarding_pick_account_state.dart';

class OnBoardingPickAccountBloc
    extends Bloc<OnBoardingPickAccountEvent, OnBoardingPickAccountState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;

  OnBoardingPickAccountBloc(this._walletUseCase, this._smartAccountUseCase)
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

      /// Create a smart account address
      final String smartAccount =
          await _smartAccountUseCase.generateSmartAccount(
        pubKey: wallet.publicKey,
      );

      /// call api check fee gas

      bool isFreeFee = false;

      if (isFreeFee) {
        emit(state.copyWith(
          status: OnBoardingPickAccountStatus.onCheckAddressEnoughFee,
        ));
      } else {
        emit(state.copyWith(
          status: OnBoardingPickAccountStatus.onCheckAddressUnEnoughFee,
          walletAddress: smartAccount,
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
