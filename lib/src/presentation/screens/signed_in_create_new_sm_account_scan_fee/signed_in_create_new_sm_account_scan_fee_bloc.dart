import 'dart:typed_data';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'signed_in_create_new_sm_account_scan_fee_event.dart';
import 'signed_in_create_new_sm_account_scan_fee_state.dart';

class SignedInCreateNewSmAccountScanFeeBloc extends Bloc<
    SignedInCreateNewSmAccountScanFeeEvent,
    SignedInCreateNewSmAccountScanFeeState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  SignedInCreateNewSmAccountScanFeeBloc(
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._accountUseCase, {
    required String smartAccountAddress,
    required Uint8List privateKey,
    required Uint8List salt,
    required String accountName,
  }) : super(
          SignedInCreateNewSmAccountScanFeeState(
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
    SignedInCreateNewSmAccountScanFeeOnCheckingBalanceEvent event,
    Emitter<SignedInCreateNewSmAccountScanFeeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SignedInCreateNewSmAccountScanFeeStatus.onCheckBalance,
      ),
    );
    try {
      bool isEnoughBalance = true;

      if (isEnoughBalance) {
        add(
          const SignedInCreateNewSmAccountScanFeeOnActiveSmartAccountEvent(),
        );
      } else {
        /// show error message for user
        emit(
          state.copyWith(
            status:
                SignedInCreateNewSmAccountScanFeeStatus.onCheckBalanceUnEnough,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SignedInCreateNewSmAccountScanFeeStatus.onCheckBalanceError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onActiveSmartAccount(
    SignedInCreateNewSmAccountScanFeeOnActiveSmartAccountEvent event,
    Emitter<SignedInCreateNewSmAccountScanFeeState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: SignedInCreateNewSmAccountScanFeeStatus.onActiveAccount,
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
        smartAccountUseCase: _smartAccountUseCase,
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
            status:
                SignedInCreateNewSmAccountScanFeeStatus.onActiveAccountSuccess,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status:
                SignedInCreateNewSmAccountScanFeeStatus.onActiveAccountError,
            errorMessage: transactionInformation.rawLog,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SignedInCreateNewSmAccountScanFeeStatus.onActiveAccountError,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
