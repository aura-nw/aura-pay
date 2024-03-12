import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
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
    on(_onChangeMemo);
    on(_onClickShowFullMessage);

    add(
      const SendTransactionConfirmationEventOnInit(),
    );
  }

  void _onClickShowFullMessage(
    SendTransactionConfirmationEventOnShowFullMessage event,
    Emitter<SendTransactionConfirmationState> emit,
  ) {
    emit(
      state.copyWith(
        isShowFullMessage: !state.isShowFullMessage,
      ),
    );
  }

  void _onChangeMemo(
    SendTransactionConfirmationEventOnChangeMemo event,
    Emitter<SendTransactionConfirmationState> emit,
  ) {
    emit(
      state.copyWith(
        memo: event.memo,
      ),
    );
  }

  void _onInit(
    SendTransactionConfirmationEventOnInit event,
    Emitter<SendTransactionConfirmationState> emit,
  ) {
    final config = getIt.get<PyxisMobileConfig>();
    final highFee = CosmosHelper.calculateFee(
      state.estimationGas,
      deNom: config.deNom,
      gasPrice: GasPriceStep.high.value,
    );
    final lowFee = CosmosHelper.calculateFee(
      state.estimationGas,
      deNom: config.deNom,
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
          memo: state.memo,
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
          memo: state.memo,
        );

        information = await wallet.submitTransaction(
          signedTransaction: tx,
        );
      }

      information = await TransactionHelper.checkTransactionInfo(
        information.txHash,
        0,
        smartAccountUseCase: _smartAccountUseCase,
      );

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
      emit(
        state.copyWith(
          status: SendTransactionConfirmationStatus.error,
          errorMsg: e.toString(),
        ),
      );
    }
  }
}
