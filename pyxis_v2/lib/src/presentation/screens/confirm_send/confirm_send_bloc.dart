import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/core/utils/aura_util.dart';
import 'package:wallet_core/wallet_core.dart';

import 'confirm_send_event.dart';
import 'confirm_send_state.dart';

final class ConfirmSendBloc extends Bloc<ConfirmSendEvent, ConfirmSendState> {
  final PyxisMobileConfig config;
  final KeyStoreUseCase _keyStoreUseCase;

  ConfirmSendBloc(
    this._keyStoreUseCase, {
    required this.config,
    required AppNetwork appNetwork,
    required Account account,
    required String amount,
    required String recipient,
    required Balance balance,
  })  : _evmChainClient = EvmChainClient(
          config.environment.evmChainInfo,
        ),
        super(
          ConfirmSendState(
            appNetwork: appNetwork,
            account: account,
            amount: amount,
            recipient: recipient,
            balance: balance,
          ),
        ) {
    on(_onInit);
    on(_onSubmit);
  }

  final EvmChainClient _evmChainClient;

  Uint8List _transaction = Uint8List(0);

  void _onInit(
    ConfirmSendOnInitEvent event,
    Emitter<ConfirmSendState> emit,
  ) async {
    try {
      final KeyStore? keyStore =
          await _keyStoreUseCase.get(state.account.keyStoreId);

      final AWallet? aWallet =
          WalletCore.storedManagement.fromSavedJson(keyStore?.key ?? '', '');

      final BigInt amount = state.balance.type.formatBalanceToInt(state.amount,
          customDecimal: state.balance.decimal);

      switch (state.appNetwork.type) {
        case AppNetworkType.evm:
          final BigInt gasPrice = await _evmChainClient.getGasPrice();

          switch (state.balance.type) {
            case TokenType.native:
              final BigInt gasEstimation = await _evmChainClient.estimateGas(
                sender: aWallet!.address,
                recipient: state.recipient,
                amount: amount,
              );
              break;
            case TokenType.erc20:
              break;
            case TokenType.cw20:
              break;
          }
          break;
        case AppNetworkType.cosmos:
          break;
        case AppNetworkType.other:
          // Currently, Pick wallet don't support this type
          break;
      }
      emit(
        state.copyWith(),
      );
    } catch (e) {
      LogProvider.log('Confirm send init error ${e.toString()}');
    }
  }

  void _onSubmit(
    ConfirmSendOnSubmitEvent event,
    Emitter<ConfirmSendState> emit,
  ) async {

    emit(state.copyWith(
      status: ConfirmSendStatus.sending,
    ));

    try {
      final String hash = await _evmChainClient.sendTransaction(
        rawTransaction: _transaction,
      );

      await _evmChainClient.verifyTransaction(hash: hash);

      emit(state.copyWith(
        status: ConfirmSendStatus.sent,
      ));

    } catch (e) {
      emit(state.copyWith(
        status: ConfirmSendStatus.error,
        error: e.toString(),
      ));
      LogProvider.log('Confirm send submit transaction error ${e.toString()}');
    }
  }
}
