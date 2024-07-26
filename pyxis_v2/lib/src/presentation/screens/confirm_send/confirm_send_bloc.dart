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
            gasEstimation: BigInt.zero,
            gasPrice: BigInt.zero,
            gasPriceToSend: BigInt.zero,
          ),
        ) {
    on(_onInit);
    on(_onSubmit);
    on(_onChangeFee);
    on(_onChangeIsShowedMsg);
  }

  final EvmChainClient _evmChainClient;

  Uint8List _transaction = Uint8List(0);

  void _onInit(
    ConfirmSendOnInitEvent event,
    Emitter<ConfirmSendState> emit,
  ) async {
    try {
      BigInt gasPrice = state.balance.type.formatBalanceToInt(
        config.config.evmInfo.gasPriceStep.average.toString(),
        customDecimal: state.balance.decimal,
      );

      emit(
        state.copyWith(
          gasPrice: gasPrice,
          gasPriceToSend: gasPrice,
        ),
      );

      final KeyStore? keyStore =
          await _keyStoreUseCase.get(state.account.keyStoreId);

      final AWallet? aWallet =
          WalletCore.storedManagement.fromSavedJson(keyStore?.key ?? '', '');

      final BigInt amount = state.balance.type.formatBalanceToInt(state.amount,
          customDecimal: state.balance.decimal);

      BigInt gasEstimation = BigInt.zero;

      Map<String, dynamic> msg = {};

      emit(
        state.copyWith(
          msg: msg,
        ),
      );

      switch (state.appNetwork.type) {
        case AppNetworkType.evm:
          gasPrice = await _evmChainClient.getGasPrice();

          switch (state.balance.type) {
            case TokenType.native:
              msg = createEvmTransferTransaction(
                privateKey: aWallet!.privateKeyData,
                chainId: BigInt.from(config.config.evmInfo.chainId),
                amount: amount,
                gasLimit: BigInt.from(21000),
                recipient: state.recipient,
                gasPrice: gasPrice,
                nonce: BigInt.zero,
              ).writeToJsonMap();

              gasEstimation = await _evmChainClient.estimateGas(
                sender: aWallet.address,
                recipient: state.recipient,
                amount: amount,
              );
              break;
            case TokenType.erc20:
              msg = createErc20TransferTransaction(
                privateKey: aWallet!.privateKeyData,
                chainId: BigInt.from(config.config.evmInfo.chainId),
                amount: amount,
                gasLimit: BigInt.from(21000),
                recipient: state.recipient,
                gasPrice: gasPrice,
                nonce: BigInt.zero,
                contractAddress: '',
              ).writeToJsonMap();
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

      gasPrice = _transformGasPrice(gasPrice);

      emit(
        state.copyWith(
          gasEstimation: gasEstimation,
          gasPrice: gasPrice,
          msg: msg,
        ),
      );
    } catch (e) {
      LogProvider.log('Confirm send init error ${e.toString()}');
    }
  }

  void _onChangeFee(
    ConfirmSendOnChangeFeeEvent event,
    Emitter<ConfirmSendState> emit,
  ) async {}

  void _onChangeIsShowedMsg(
    ConfirmSendOnChangeIsShowedMessageEvent event,
    Emitter<ConfirmSendState> emit,
  ) async {
    emit(state.copyWith(
      status: ConfirmSendStatus.init,
      isShowFullMsg: !state.isShowFullMsg,
    ));
  }

  void _onSubmit(
    ConfirmSendOnSubmitEvent event,
    Emitter<ConfirmSendState> emit,
  ) async {
    emit(state.copyWith(
      status: ConfirmSendStatus.sending,
    ));

    final KeyStore? keyStore =
        await _keyStoreUseCase.get(state.account.keyStoreId);

    final AWallet? aWallet =
        WalletCore.storedManagement.fromSavedJson(keyStore?.key ?? '', '');

    try {
      switch (state.appNetwork.type) {
        case AppNetworkType.evm:
          final evmTransaction =
              await _evmChainClient.createTransferTransaction(
            wallet: aWallet!,
            amount: state.balance.type.formatBalanceToInt(
              state.amount,
              customDecimal: state.balance.decimal,
            ),
            gasLimit: BigInt.from(21000),
            recipient: state.recipient,
            gasPrice: state.gasPriceToSend,
          );

          final String hash = await _evmChainClient.sendTransaction(
            rawTransaction: Uint8List.fromList(evmTransaction.encoded),
          );

          LogProvider.log('receive hash $hash');

          await _evmChainClient.verifyTransaction(hash: hash);

          emit(state.copyWith(
            status: ConfirmSendStatus.sent,
          ));
          break;
        case AppNetworkType.cosmos:
          break;
        case AppNetworkType.other:
          break;
      }
    } catch (e) {
      emit(state.copyWith(
        status: ConfirmSendStatus.error,
        error: e.toString(),
      ));
      LogProvider.log('Confirm send submit transaction error ${e.toString()}');
    }
  }

  BigInt _transformGasPrice(BigInt gasPrice) {
    BigInt lowGasPrice = state.balance.type.formatBalanceToInt(
      config.config.evmInfo.gasPriceStep.low.toString(),
      customDecimal: state.balance.decimal,
    );

    if (gasPrice < lowGasPrice) {
      return lowGasPrice;
    }

    return gasPrice;
  }
}
