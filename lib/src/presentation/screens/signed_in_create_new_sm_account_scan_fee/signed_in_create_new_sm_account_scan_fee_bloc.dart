import 'dart:typed_data';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          status:
              SignedInCreateNewSmAccountScanFeeStatus.onActiveAccountSuccess,
        ),
      );
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
