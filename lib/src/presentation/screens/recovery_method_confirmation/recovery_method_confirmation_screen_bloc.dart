import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'recovery_method_confirmation_screen_event.dart';
import 'recovery_method_confirmation_screen_state.dart';

final class RecoveryMethodConfirmationBloc extends Bloc<
    RecoveryMethodConfirmationEvent, RecoveryMethodConfirmationState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  RecoveryMethodConfirmationBloc(
    this._smartAccountUseCase,
    this._controllerKeyUseCase, {
    required AuraAccount account,
    required GoogleAccount googleAccount,
  }) : super(
          RecoveryMethodConfirmationState(
            account: account,
            googleAccount: googleAccount,
          ),
        ) {
    on(_onChangeFee);
    on(_onConfirm);
  }

  void _onChangeFee(
    RecoveryMethodConfirmationEventOnChangeFee event,
    Emitter<RecoveryMethodConfirmationState> emit,
  ) async {
    emit(
      state.copyWith(transactionFee: event.fee),
    );
  }

  void _onConfirm(
    RecoveryMethodConfirmationEventOnConfirm event,
    Emitter<RecoveryMethodConfirmationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RecoveryMethodConfirmationStatus.onRecovering,
      ),
    );

    try {
      final String? smPrivateKey = await _controllerKeyUseCase.getKey(
        address: state.account.address,
      );


      TransactionInformation information = await _smartAccountUseCase.setRecoveryMethod(
        userPrivateKey: AuraWalletHelper.getPrivateKeyFromString(smPrivateKey!),
        smartAccountAddress: state.account.address,
        recoverAddress: 'aura176wt9d8zdg0dgrtvzxvplgdmv99j5yn3enpedl',
      );
      print(information.txHash);

      information = await _checkTransactionInfo(information.txHash,0);

      if(information.status == 0){
        emit(
          state.copyWith(
            status: RecoveryMethodConfirmationStatus.onRecoverSuccess,
          ),
        );
      }else{
        emit(
          state.copyWith(
            status: RecoveryMethodConfirmationStatus.onRecoverFail,
            error: information.rawLog,
          ),
        );
      }


    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: RecoveryMethodConfirmationStatus.onRecoverFail,
          error: e.toString(),
        ),
      );
    }
  }

  Future<TransactionInformation> _checkTransactionInfo(
      String txHash, int times) async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    try {
      return await _smartAccountUseCase.getTx(
        txHash: txHash,
      );
    } catch (e) {
      if (times == 4) {
        rethrow;
      }
      return _checkTransactionInfo(txHash, times + 1);
    }
  }
}
