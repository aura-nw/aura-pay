import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
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
        ) {
    on(_onInit);
    on(_onChangeFee);
    on(_onSendToken);

    add(
      const SendTransactionConfirmationEventOnInit(),
    );
  }

  void _onInit(
    SendTransactionConfirmationEventOnInit event,
    Emitter<SendTransactionConfirmationState> emit,
  ) {
    final highFee = CosmosHelper.calculateFee(
      state.estimationGas,
      deNom: AuraSmartAccountCache.deNom,
      gasPrice: GasPriceStep.high.value,
    );
    final lowFee = CosmosHelper.calculateFee(
      state.estimationGas,
      deNom: AuraSmartAccountCache.deNom,
      gasPrice: GasPriceStep.low.value,
    );

    emit(state.copyWith(
      highTransactionFee: highFee.amount[0].amount,
      lowTransactionFee: lowFee.amount[0].amount,
    ));
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

      late TransactionInformation information;

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
          amount: state.amount.toDenom,
          fee: state.transactionFee,
          gasLimit: state.estimationGas,
        );

        information = await wallet.submitTransaction(
          signedTransaction: tx,
        );
      }

      information = await _checkTransactionInfo(information.txHash, 0);

      if (information.status == 0) {
        emit(
          state.copyWith(
            status: SendTransactionConfirmationStatus.success,
            transactionInformation: information,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMsg: information.rawLog,
            status: SendTransactionConfirmationStatus.error,
          ),
        );
      }
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
