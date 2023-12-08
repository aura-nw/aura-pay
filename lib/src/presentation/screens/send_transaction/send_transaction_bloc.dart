import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/helpers/wallet_address_validator.dart';
import 'send_transaction_event.dart';
import 'send_transaction_state.dart';

final class SendTransactionBloc
    extends Bloc<SendTransactionEvent, SendTransactionState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  SendTransactionBloc(
    this._auraAccountUseCase,
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
  ) : super(
          const SendTransactionState(),
        ) {
    on(_onInit);
    on(_onChangeRecipientAddress);
    on(_onChangeAmount);
    on(_onEstimateFee);
  }

  void _onInit(
    SendTransactionEventOnInit event,
    Emitter<SendTransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SendTransactionStatus.loading,
      ),
    );
    try {
      // Get first account
      final AuraAccount  ? account = await _auraAccountUseCase.getFirstAccount();

      final String balance = await _smartAccountUseCase.getToken(
        address: account?.address ?? '',
      );

      emit(
        state.copyWith(
          status: SendTransactionStatus.loaded,
          sender: account,
          balance: balance,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SendTransactionStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onChangeRecipientAddress(
    SendTransactionEventOnChangeRecipientAddress event,
    Emitter<SendTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        recipientAddress: event.address,
        isReadySubmit: _isReady(
          state.amount,
          event.address,
        ),
      ),
    );
  }

  void _onChangeAmount(
    SendTransactionEventOnChangeAmount event,
    Emitter<SendTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        amount: event.amount,
        isReadySubmit: _isReady(
          event.amount,
          state.recipientAddress,
        ),
      ),
    );
  }

  void _onEstimateFee(
    SendTransactionEventOnEstimateFee event,
    Emitter<SendTransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SendTransactionStatus.onEstimateFee,
      ),
    );
    try {
      final sender = state.sender!;

      final String privateKeyString = (await _controllerKeyUseCase.getKey(
        address: sender.address,
      ))!;

      final int gasLimit = await _smartAccountUseCase.simulateFee(
        userPrivateKey: AuraWalletHelper.getPrivateKeyFromString(
          privateKeyString,
        ),
        smartAccountAddress: sender.address,
        receiverAddress: state.recipientAddress,
        amount: state.amount.toDenom,
      );

      final fee = CosmosHelper.calculateFee(
        gasLimit,
        deNom: AuraSmartAccountCache.deNom,
      );

      final amount = fee.amount[0];

      emit(
        state.copyWith(
          estimateFee: amount.amount,
          status: SendTransactionStatus.estimateFeeSuccess,
          gasEstimation: fee.gasLimit.toInt(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SendTransactionStatus.estimateFeeError,
          error: e.toString(),
        ),
      );
    }
  }

  bool _isReady(String amount, String recipient) {
    try {
      double am = double.parse(amount);

      double total = double.parse(state.balance);

      if(am > total || am == 0){
        return false;
      }

      return WalletAddressValidator.isValidAddress(recipient);
    } catch (e) {
      return false;
    }
  }
}
