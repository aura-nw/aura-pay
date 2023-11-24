import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_scan_fee_event.dart';
import 'on_boarding_scan_fee_state.dart';

class OnBoardingScanFeeBloc
    extends Bloc<OnBoardingScanFeeEvent, OnBoardingScanFeeState> {
  final SmartAccountUseCase _smartAccountUseCase;

  OnBoardingScanFeeBloc(
    this._smartAccountUseCase, {
    required String smartAccountAddress,
  }) : super(
          OnBoardingScanFeeState(
            smartAccountAddress: smartAccountAddress,
          ),
        ) {
    on(_onCheckingBalance);
    on(_onActiveSmartAccount);
  }

  void _onCheckingBalance(
    OnBoardingScanFeeOnCheckingBalanceEvent event,
    Emitter<OnBoardingScanFeeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OnBoardingScanFeeStatus.onCheckBalance,
      ),
    );
    try {
      bool isEnoughBalance = true;

      if (isEnoughBalance) {
        /// call active smart account
        emit(
          state.copyWith(
            status: OnBoardingScanFeeStatus.onActiveAccount,
          ),
        );

        await Future.delayed(
          const Duration(
            seconds: 2,
          ),
        );

        emit(
          state.copyWith(
            status: OnBoardingScanFeeStatus.onActiveAccountSuccess,
          ),
        );
      } else {
        /// show error message for user
        emit(
          state.copyWith(
            status: OnBoardingScanFeeStatus.onCheckBalanceUnEnough,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingScanFeeStatus.onCheckBalanceError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onActiveSmartAccount(
    OnBoardingScanFeeOnActiveSmartAccountEvent event,
    Emitter<OnBoardingScanFeeState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: OnBoardingScanFeeStatus.onActiveAccount,
        ),
      );

      await _smartAccountUseCase.activeSmartAccount(
        userPrivateKey: Uint8List(0),
        smartAccountAddress: state.smartAccountAddress,
        fee: '0.0025',
        gasLimit: 400000,
        memo: 'Active smart account',
      );

      emit(
        state.copyWith(
          status: OnBoardingScanFeeStatus.onActiveAccountSuccess,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingScanFeeStatus.onActiveAccountError,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
