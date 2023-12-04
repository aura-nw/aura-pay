import 'dart:typed_data';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_scan_fee_event.dart';
import 'on_boarding_scan_fee_state.dart';

class OnBoardingScanFeeBloc
    extends Bloc<OnBoardingScanFeeEvent, OnBoardingScanFeeState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  OnBoardingScanFeeBloc(
    this._smartAccountUseCase,
    this._accountUseCase,
    this._controllerKeyUseCase, {
    required String smartAccountAddress,
    required Uint8List privateKey,
    required Uint8List salt,
    required String accountName,
  }) : super(
          OnBoardingScanFeeState(
            smartAccountAddress: smartAccountAddress,
            privateKey: privateKey,
            salt: salt,
            accountName: accountName,
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
        add(
          const OnBoardingScanFeeOnActiveSmartAccountEvent(),
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
        userPrivateKey: state.privateKey,
        smartAccountAddress: state.smartAccountAddress,
        salt: state.salt,
        fee: '2500',
        gasLimit: 400000,
        memo: 'Active smart account',
      );

      await _accountUseCase.saveAccount(
        address: state.smartAccountAddress,
        accountName: state.accountName,
        type: AuraAccountType.smartAccount,
      );

      await _controllerKeyUseCase.saveKey(
        address: state.smartAccountAddress,
        key: AuraWalletHelper.getPrivateKeyFromBytes(
          state.privateKey,
        ),
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
