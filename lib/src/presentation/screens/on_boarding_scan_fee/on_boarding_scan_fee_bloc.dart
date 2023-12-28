import 'dart:typed_data';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'on_boarding_scan_fee_event.dart';
import 'on_boarding_scan_fee_state.dart';

class OnBoardingScanFeeBloc
    extends Bloc<OnBoardingScanFeeEvent, OnBoardingScanFeeState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final TransactionUseCase _transactionUseCase;

  OnBoardingScanFeeBloc(
    this._smartAccountUseCase,
    this._accountUseCase,
    this._controllerKeyUseCase,
    this._transactionUseCase, {
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

  final config = getIt.get<PyxisMobileConfig>();

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

      TransactionInformation transactionInformation =
          await _smartAccountUseCase.activeSmartAccount(
        userPrivateKey: state.privateKey,
        smartAccountAddress: state.smartAccountAddress,
        salt: state.salt,
        memo: 'Active smart account',
      );

      transactionInformation = await TransactionHelper.checkTransactionInfo(
        transactionInformation.txHash,
        0,
        transactionUseCase: _transactionUseCase,
        config: config,
      );

      if (transactionInformation.status == 0) {
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
      } else {
        emit(
          state.copyWith(
            status: OnBoardingScanFeeStatus.onActiveAccountError,
            errorMessage: transactionInformation.rawLog,
          ),
        );
      }
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
