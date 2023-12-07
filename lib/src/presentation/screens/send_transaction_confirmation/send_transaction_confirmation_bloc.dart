import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'send_transaction_confirmation_event.dart';
import 'send_transaction_confirmation_state.dart';

class SendTransactionConfirmationBloc extends Bloc<
    SendTransactionConfirmationEvent, SendTransactionConfirmationState> {
  final ControllerKeyUseCase _controllerKeyUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final WalletUseCase _walletUseCase;

  SendTransactionConfirmationBloc(
    this._smartAccountUseCase,
    this._walletUseCase,
    this._controllerKeyUseCase, {
    required AuraAccount sender,
    required String recipient,
    required String amount,
    required String transactionFee,
    required int estimationGas,
  }) : super(
          SendTransactionConfirmationState(
            sender: sender,
            recipient: recipient,
            amount: amount,
            transactionFee: transactionFee,
            estimationGas: estimationGas,
          ),
        ){
    on(_onChangeFee);
    on(_onSendToken);
  }

  void _onChangeFee(
    SendTransactionConfirmationEventOnChangeFee event,
    Emitter<SendTransactionConfirmationState> emit,
  ) {
    emit(
      state.copyWith(
        transactionFee: event.fee,
      ),
    );
  }

  void _onSendToken(
    SendTransactionConfirmationEventOnSendToken event,
    Emitter<SendTransactionConfirmationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SendTransactionConfirmationStatus.loading,
      ),
    );
    try {
      //switch type
      final sender = state.sender;

      final String privateKeyString = (await _controllerKeyUseCase.getKey(
        address: sender.address,
      ))!;

      late SendTransactionInformation information;

      if (state.sender.type == AuraAccountType.smartAccount) {
        // send token by smart account
        information = await _smartAccountUseCase.sendToken(
          userPrivateKey:
              AuraWalletHelper.getPrivateKeyFromString(privateKeyString),
          smartAccountAddress: sender.address,
          receiverAddress: state.recipient,
          amount: state.amount.toDenom,
          fee: state.transactionFee,
          gasLimit: state.estimationGas,
        );
      } else {

        // send token by normal wallet

        final wallet = await _walletUseCase.importWallet(
          privateKeyOrPassPhrase: privateKeyString,
        );

        final tx = await wallet.sendTransaction(
          toAddress: state.recipient,
          amount: state.amount,
          fee: state.transactionFee,
          gasLimit: state.estimationGas,
        );

        information = await wallet.submitTransaction(
          signedTransaction: tx,
        );
      }

      emit(
        state.copyWith(
          status: SendTransactionConfirmationStatus.success,
          sendTransactionInformation: information,
        ),
      );
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: SendTransactionConfirmationStatus.error,
          errorMsg: e.toString(),
        ),
      );
    }
  }
}
