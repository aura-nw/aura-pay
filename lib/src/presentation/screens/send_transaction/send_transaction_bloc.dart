import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/helpers/wallet_address_validator.dart';
import 'send_transaction_event.dart';
import 'send_transaction_state.dart';

final class SendTransactionBloc
    extends Bloc<SendTransactionEvent, SendTransactionState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final SmartAccountUseCase _smartAccountUseCase;

  SendTransactionBloc(this._auraAccountUseCase, this._smartAccountUseCase)
      : super(
          const SendTransactionState(),
        ) {
    on(_onInit);
    on(_onChangeRecipientAddress);
    on(_onChangeAmount);
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
      final AuraAccount? account = await _auraAccountUseCase.getFirstAccount();

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

  bool _isReady(String amount, String recipient) {
    try {
      double am = double.parse(amount);

      if (am == 0) return false;

      return WalletAddressValidator.isValidAddress(recipient);
    } catch (e) {
      return false;
    }
  }
}
